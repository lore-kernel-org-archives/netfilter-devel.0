From: Ansis Atteka <aatteka@nicira.com>
Subject: Re: [PATCH] conntrackd: make conntrackd namespace aware
Date: Fri, 28 Sep 2012 13:05:14 -0700
Message-ID: <CAA=3OqkQyhsJAtgjKFpKBeDqYia=5ue-78W43X7ndCW7UsYcEQ@mail.gmail.com>
References: <1346461915-6309-1-git-send-email-aatteka@nicira.com>
	<20120906170253.GA17317@1984>
	<CAA=3Oq=G9g=9LkKxhobU1cTLtU3jyuGJZn4kn_E4LJXk11Escw@mail.gmail.com>
	<20120911154458.GB28012@1984>
	<CAA=3Oqm_tGgKpWf2V=Ki7Le-UcA7o_-_o+77TRjPX6-4RYha2Q@mail.gmail.com>
	<20120918192320.GA1182@1984>
	<CAA=3OqkaM_s4DEdL3D8tG5SCkRpubgzfw2a0snGZBGU0KD09Gg@mail.gmail.com>
	<20120919082143.GA20453@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:60403 "HELO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030515Ab2I1UFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:05:17 -0400
Received: by mail-wg0-f42.google.com with SMTP id fm10so224567wgb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Sep 2012 13:05:14 -0700 (PDT)
In-Reply-To: <20120919082143.GA20453@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 19, 2012 at 1:21 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 18, 2012 at 03:36:54PM -0700, Ansis Atteka wrote:
>> On Tue, Sep 18, 2012 at 12:23 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Thu, Sep 13, 2012 at 12:37:18AM -0700, Ansis Atteka wrote:
>> > [...]
>> >> I know that this would be a massive change, so I might miss
>> >> something in the proposal. Anyway feel free to correct me or ask for
>> >> more details where necessary. Here is a list of necessary changes:
>> >>
>> >> 1. Quite a lot of refactoring in configuration parser.
>> >>
>> >> I would suggest to split ct_conf struct into three logical pieces (i.e. smaller
>> >> structs):
>> >> a. channel config (instance per remote conntrackd instance)
>> >> b. conntrack-state config (instance per namespace)
>> >> c. static/global config (single instance; Would contain path to log
>> >> file, unix socket e.t.c.)
>> >
>> > I always wanted to clean up ct_conf. See patch attached, I didn't
>> > commit it yet since I want to give it some test (Please, not need to
>> > rebase the patch we're currently discussing upon it).
>>
>> I don't see any patches attached.
>
> Sorry, here it is.
>
>> >> This decoupling would allow much more easily to maintain relation
>> >> between conntrack-states and channels (for example, when multiple
>> >> namespaces are using the same channel).
>> >
>> > I'm not familiar with the channel definition you're using.
>>
>> By "channel" I meant channel & channel_ops structures.
>>
>> > link abstraction (ie. TCP / UDP / MCAST / TIPC ...).
>>
>> I guess we are actually talking about the same thing.
>
> OK, so what new channel do you need to add. What communication
> primitive will it use?
Sorry, I guess I did not deliver my point correctly.

I do not intend to add new type of channel.

What I thought was to break current conntrackd *state structures into following
logical pieces:
1. Global state (e.g. local_server, fds ...)
2. Namespace related state (e.g. nfct_handles, namespace fd ...)
3. Channel & Sync state (e.g. multichannel, tx_queue ...)

I will soon send a patch to demonstrate, what I am intending to do.
>
>> >> Also, currently CONFIG(X) macro allows to reference only a single ct_conf
>> >> instance. This will need to be changed so that each namespace has its own
>> >> ct_conf_sync instance. And each channel has its own ct_conf_channel instance.
>> >>
>> >> Also, I am afraid that, for this to make more sense, I would have to extend
>> >> conntrackd.conf syntax, For example,introduce following top-level sections:
>> >> channel {}, sync {} and global {} respectively.
>> >>
>> >> 2. Allow to add, remove and list configuration dynamically without
>> >> restarting conntrackd. This would require ability to start conntrackd
>> >> with minimal global/static configuration. After that add namespaces and
>> >> channel configuration by using Unix Domain socket.
>> >>
>> >> For example, instead of starting conntrackd with following command:
>> >> conntrackd -C /etc/conntrackd/conntrackd.conf
>> >>
>> >> One would have to use something like this:
>> >> conntrackd --global-config /etc/conntrackd/conntrackd_global.conf #
>> >> This config file would just specify Unix socket, log file e.t.c.
>> >> and then on-the-fly add channel and namespace configuration with:
>> >> conntrackd -U /var/run/conntrackd.ctl --add
>> >> /etc/conntrackd/conntrackd_namespace1.conf
>> >> conntrackd -U /var/run/conntrackd.ctl --add
>> >> /etc/conntrackd/conntrackd_channel1.conf
>> >> conntrackd -U /var/run/conntrackd.ctl --add
>> >> /etc/conntrackd/conntrackd_namespace2.conf
>> >> conntrackd -U /var/run/conntrackd.ctl --add
>> >> /etc/conntrackd/conntrackd_channel2.conf
>> >>
>> >> We could glue namespaces together with channels by using some IDs.
>> >>
>> >> Another question is, whether over the Unix domain socket we would prefer to
>> >> transfer binary (already parsed) or textual (yet unparsed) configuration?
>> >>
>> >> Also, I would need to figure out if/how to maintain backward compatibility with
>> >> already existing commands, when there are multiple namespaces (e.g. dump
>> >> internal cache, commit external cache ...).
>> >>
>> >> 3. Wire protocol format improvements, so that namespace ID would be encapsulated
>> >> into the protocol too. This is required, when same channel is being
>> >> used by multiple namespaces.
>> >
>> > This only requires adding one new TLV attribute to identify this. So
>> > we don't need to bloat the header with one field that is not use.
>>
>> Here is how I am currently doing that:
>>
>> struct nethdr {
>> #if __BYTE_ORDER == __LITTLE_ENDIAN
>>       uint8_t type:4,
>>               version:4;
>> #elif __BYTE_ORDER == __BIG_ENDIAN
>>       uint8_t version:4,
>>               type:4;
>> #else
>> #error  "Unknown system endianess!"
>> #endif
>>       uint8_t flags;
>>       uint16_t len;
>>       uint32_t seq;
>>       uint32_t nsid; < -present only if nethdr.flag &
>> };
>> nsid is the namespace id. This field would be present only
>> if nethdr.flags & NET_F_NAMESPACE != 0.
>
> That adds an always zero field for the non-namespace case in the
> protocol fixed header. TLVs can be used for optional fields.
>
>> Could you please elaborate more on your suggested approach? If I
>> understand it correctly, then you want to add the namespace id
>> inside the data section that follows immediately after the nethdr
>> structure as TLV variable?
>
> Yes.
>
> See enum nta_attr and add NTA_NAMESPACE and NTA_EXP_NAMESPACE. Then
> implement that attribute in src/build.c and src/parse.c.
>
> You can change msg2ct_alloc and msg2exp_alloc to return the netns
> value:
>
> struct nf_conntrack *msg2ct_alloc(struct nethdr *net, int remain, int *ns);
>
>> Also, if I understand correctly, then after nethdr conntrackd
>> simply transfers nf_conntrack struct (or the contents of cache
>> object). I have had imagined that we should have cache table
>> per namespace, so storing namespace id inside nf_conntrackd
>> would become redundant.
>
> You don't need to store in the struct nf_conntrack, you can slightly
> generalize the parse function to:
>
> static void
> ns_parse_u32(void *data, int attr, void *data)
> {
>         int *ns = data;
>
>         *ns = ntohl(*ns);
> }
>
> No need to always take struct nf_conntrack as first parameter. Then
> msg2ct returns the namespace.
>

So, if we deliver namespace ID as TLV variable, then it seems more
natural to share the same reliability layer (in nethdr) for all
namespaces.

This will get a little bit tricky how to pass down the namespace id
from event_handler() to tx_queue_xmit() function.

>> What is your take on this?
>>
>> >
>> >> 4. Similarly as CONFIG(x) was broken down into 3 logical pieces, the
>> >> same thing would
>> >> need to be done for STATE(x) macros.
>> >
>> > This seems to be a huge changeset what you're proposing.
>> >
>> > I need some convincing architecture example that describes how this
>> > can be used before you submit such a big patch. I need to understand
>> > it to know if there is a different way to make this.
>
> Still waiting for the description of the big picture of the
> architecture.

Sorry for late response, but I thought that the best way to propose
this would be by sending a RFC patch. Will do that by Monday.

Currently what I have implemented is:
1. Add new configuration through Unix domain socket (input is
namespace ID and namespace mount point)
2. event_handler() function now receives CT events from multiple
namespaces that were added through Unix Domains socket
3. hardcoded namespace ID is now transferred as TLV variable over wire protocol

I will soon add following:
1. instead of sending hardcoded namespace id use the one received in
event_handler() (see tx_queue_xmit() discussion above)
2. namespace state lookup from namespace id in the
do_channel_handler_step(). This will require hashmap.

Once that will be done, then this patch would allow to synchronize the
*same set* of namespaces between two conntrackd instances.

After that I intend to send another patch that would allow to
synchronize subset of namespaces with one conntrackd and another
subset with different conntrackd. This will require conntrackd to
maintain multiple active channels and sync states.
