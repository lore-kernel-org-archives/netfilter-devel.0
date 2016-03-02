From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH 1/2] iptables: utils: Add bash completion
Date: Wed, 2 Mar 2016 20:26:49 +0100
Message-ID: <56D73E79.40309@chello.at>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
 <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at>
 <20160302113411.GA2068@salvia> <56D6DB61.7070203@chello.at>
 <20160302125445.GA5129@salvia>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Giuseppe Longo <giuseppelng@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vie01a-dmta-at01-3.mx.upcmail.net ([62.179.121.147]:31456 "EHLO
	vie01a-dmta-at01-3.mx.upcmail.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751830AbcCBT0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 14:26:53 -0500
Received: from [172.31.216.43] (helo=vie01a-pemc-psmtp-pe01)
	by vie01a-dmta-at01.mx.upcmail.net with esmtp (Exim 4.72)
	(envelope-from <mart.frauenlob@chello.at>)
	id 1abCQ6-0002tr-Gj
	for netfilter-devel@vger.kernel.org; Wed, 02 Mar 2016 20:26:50 +0100
In-Reply-To: <20160302125445.GA5129@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.03.2016 13:54, Pablo Neira Ayuso wrote:
> On Wed, Mar 02, 2016 at 01:24:01PM +0100, Mart Frauenlob wrote:
>> On 02.03.2016 12:34, Pablo Neira Ayuso wrote:
>>> On Thu, Feb 25, 2016 at 04:06:53PM +0100, Mart Frauenlob wrote:
>>>>   utils/iptables_bash_completion/README.md |  290 ++++
>>>>   utils/iptables_bash_completion/iptables  | 2426 ++++++++++++++++++++++++++++++
>>>
>>> This is fair good amount of work, but this is also quite a bit of
>>> new shell code to be maintained in our trees.
>>>
>>> Moreover, I was told that, in the specific case of debian, there is a
>>> package (bash-completion) where you place this.
>>>
>>> So sorry, I'm not applying this.

[...]

>> I think this is a good piece of work, probably the best featured bash
>> completion ever, and I'd wish to get it distributed.
>> My abilities in that matter are limited.
>>
>> Of course I'd keep fixing bugs and add new iptables features (though I think
>> there are not many to expect in the future, right?).
>> If someone submits a bug report, I'll take care of it if anyhow possible.
>> Just need to be notified by CC or so.
>
> Then, my suggestion is to simplify this script in order to reduce the
> maintainance burden.

Excuse me I'm unsure what maintenance burden you are expecting.
 From my point of view I don't see it.
Bug reports for this for sure have low priority.
Jozsef has my ipset completion in his tree for long time and afaik only 
one false bug report was sent (he just applied my patch to add it to build).
The script is well structured, it should not be hard to fix.
Adding new extensions or options of them is in most cases just an entry 
in the matches/targets array.
If an option requires input, then one entry at the option request 
section is needed:
elif [[ $prev = --new-option ]]; then return 0

And if completion on the value is possible:
elif [[ $prev = --new-option ]]; then complete_new_option_value ...

It's a little bit more work if an extension is protocol depending, but 
that's most likely just an entry in an extglob i.e. 
(tcp|upd|icmp|new_ext) in the get_match/target_opts() functions.
More complex are overlapping option names (hopefully that will never 
happen again in the future).

I can put more documentation into the source, to make it easier to follow.
As said I'll help on fixing bugs.

> One idea is to push into iptables some infrastructure so the script
> can inquire iptables on available options. This would be simple C code
> to be places on every extension to print the options. Then, add a tool
> like iptables-completion that you can use to inquire what is possible
> to get as options. Thus, we get a generic script that inquires
> iptables, instead of having them all hardcoded into the script.
>
> Would you explore this? I know Giuseppe Longo and Eric Leblond are
> looking into this for nft following a similar approach.

Maybe, see below.
But is it worth it? Correct me if I got the wrong impression.
nft will be/is the successor of iptables and most work in iptables will 
go into iptables-translate.
So why not just take the "classical" approach here and add that fancy 
featured completion and put the focus on the new tools?
I'm willing to help there (mainly on the shell side), if wanted.

Now for the new infrastructure:
Retrieving just the options is a fairly small part of my completion 
code. There are many other things I take into account. I try to list 
them all here (hopefully not missing one).
If any of these information is missing, I think it needs to be stored 
hard-coded.

- list of all extensions available - need to know if match or target
- table in which it is valid
- valid for ipv4 or ipv6 or both
- if extension is only valid for certain protocols
- does the core or extension option allow inversion
- which extension options are mandatory
- which core or extension options are mutually exclusive
- which extension options are only valid for certain protocols
- if out of a selection of extension options one is needed (i.e. recent 
match: --rcheck, --update, --remove)
- if an extension option is (in)valid depending on another of its 
options values (i.e. statistic match with --probability and --mode = random)
- core and extension options aliases (i.e. --destination-port, --dport)
- if it is valid to use a match or match option multiple times

Is all this info stored somewhere within iptables?

Also, the reply from he new iptables-completion tool may still need 
parsing, option and option alias de-duping (if not all will be done in C).
A parameter to show long or short or both form of options (I have an 
option in my completion that lets the user choose) would be needed.

So I think for it to be efficient in reducing shell code, I'd need to 
tell the new tool what information I have retrieved from the iptables 
command line. So it can based on that send back completion information. 
i.e. iptables -t filter -p tcp -m[TAB] - is what I have.
The optimal reply would be: all matches that are present on the system, 
are valid in the filter table and are valid for the tcp protocol.
If ! -p tcp is specified, I'd of course expect a different reply.

For non option completion I don't see much of a chance for code 
reduction. Unless for some exceptions like REJECT --reject-type (here 
the protocol is of interest), or -m icmp --icmp-type, or AUDIT --type 
xyz (in that case completion code is so tiny, an external program call 
is not worth it at all) ... where the extension knows very well about 
the expected values. If that kind of information (based on the 
parameters used) can be sent back, that could be useful.

Retrieving builtin chains and retrieving user defined chains would be 
nice to have. Saves the parsing of the output of iptables -S.
Another thing may be protocols/service names. As iptables knows the 
names, it may be possible to return them for completion, so not to parse 
the files from /etc/{services,protocols} with the shell.

If you think this can be done with affordable effort I'm willing to 
help. But mainly on the shell side, as I'm no C programmer. Maybe 
replicating code to other extensions, if someone does a template, is 
possible for me.

Best regards,

Mart



