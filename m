From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 23:54:27 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501202346450.3962@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>   
	<20050114143722.GA10088@ti64.telemetry-investments.com>   
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>   
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>   
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<41E7F2DA.608@info-link.net> <41E7F4B9.4080103@info-link.net>
	<Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
	<41EFDDE2.8030901@info-link.net>
	<Pine.LNX.4.61.0501201759360.1703@bizon.gios.gov.pl>
	<13851.142.169.215.10.1106246038.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1302136555-1106261667=:3962"
Cc: Brad Fisher <brad@info-link.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <13851.142.169.215.10.1106246038.squirrel@142.169.215.10>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1302136555-1106261667=:3962
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 20 Jan 2005, Samuel Jean wrote:

> Hi!
>
> On Thu, January 20, 2005 12:18 pm, Krzysztof Oledzki said:
>
> ..snip..
>
>> On Thu, 20 Jan 2005, Brad Fisher wrote:
>>> To match 20:00 - 4:00 you currently need 2 rules:
>>> 1) match 20:00 - 23:59
>>> 2) match 0:00 - 4:00
>>> What I'm proposing is to allow this to be reduced to one rule.
>
> What Brad proposes makes so much sense, IMHO. I haven't looked at this
> code yet (ipt_time) but I thought it already behaves that way. Apperently
> not, since you both complain about it.
>
>>
>> So, again.. You need something like invert flag in -m like in the -p:
>>
>> iptables -A something ! -m time --timestart 4:01 --timestop 19:59 -j
>> DoSomething
>>
>> This one should match 20:00-20:59 and 0:00-4:00, true?
>
> I wasn't aware you can negate --match options. Are you sure we can do thi=
s ?

No, unfortunately we can't AFAIK. For unknown reasons to me, we can only=20
negate -p (protocol) but not the -m. Please, look at the iptables.c:

(...)
switch (c) {
         /*
          * Command selection
          */
(...)
case 'p':
         check_inverse(optarg, &invert, &optind, argc);
         set_option(&options, OPT_PROTOCOL, &fw.ip.invflags,
                    invert);

         /* Canonicalize into lower case */
         for (protocol =3D argv[optind-1]; *protocol; protocol++)
                 *protocol =3D tolower(*protocol);

         protocol =3D argv[optind-1];
         fw.ip.proto =3D parse_protocol(protocol);

         if (fw.ip.proto =3D=3D 0
             && (fw.ip.invflags & IPT_INV_PROTO))
                 exit_error(PARAMETER_PROBLEM,
                            "rule would never match protocol");
         fw.nfcache |=3D NFC_IP_PROTO;
         break;
(...)
case 'm': {
         size_t size;

         if (invert)
                 exit_error(PARAMETER_PROBLEM,
                            "unexpected ! flag before --match");

         m =3D find_match(optarg, LOAD_MUST_SUCCEED, &matches);
         size =3D IPT_ALIGN(sizeof(struct ipt_entry_match))
                          + m->size;
         m->m =3D fw_calloc(1, size);
         m->m->u.match_size =3D size;
         strcpy(m->m->u.user.name, m->name);
         m->init(m->m, &fw.nfcache);
         opts =3D merge_options(opts, m->extra_opts, &m->option_offset);
}
break;
(...)


>> Right now you can use:
>>
>> iptables -N Match20_4
>> iptables -A Match20_4 -m time --timestart 4:01 --timestop 19:59 -j RETUR=
N
>> iptables -A Match20_4 -j DoSomething
>>
>> This one should match 20:00-20:59 and 0:00-4:00, true?
>
> Yes, but rather ugly :) I strongly suggest adding support to it. As Brad
> did mention, another 'if' condition produces less latency than superfluou=
s
> packet iteration.

I'm not sure if adding a negation-like-workaround to ipt_time (and=20
possible other matches like ipt_limit) is a good idea. My qestion is: why=
=20
we cannot simply negate all matches?


Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1302136555-1106261667=:3962--
