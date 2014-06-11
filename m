From: Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 16:03:15 +0400
Message-ID: <1402488195.32126.70.camel@tkhai>
References: <1396871929.3741.6.camel@tkhai>
	  <20140428142306.GA28547@localhost> <1402487079.32126.54.camel@tkhai>
	  <20140611114957.GA23352@localhost> <1402487718.32126.63.camel@tkhai>
	 <53984482.5060309@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	"Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>, <tkhai@yandex.ru>
To: Pavel Emelyanov <xemul@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:58835 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaFKMD0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:03:26 -0400
In-Reply-To: <53984482.5060309@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D0=92 =D0=A1=D1=80, 11/06/2014 =D0=B2 15:58 +0400, Pavel Emelyanov =D0=
=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 06/11/2014 03:55 PM, Kirill Tkhai wrote:
>=20
> >> How it this combination being triggered there? I mean:
> >>
> >> # modprobe dummy
> >> # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP ...
> >> # rmmod dummy
> >>
> >> Is it something included in some scripts that automate the setup?
> >=20
> > It's a sample of how to trigger this. The problem is not in rmmod.
> >=20
> > Really it happens when container is stopping and device is going aw=
ay.
> > It's not OpenVZ related, current LXC has the same problem.
>=20
> Then it should be reproducible with the help of simple 'unshare --net=
'
> plus 'ip link add ...' commands that would create netns and populate
> it with devices. Right?

Yes, exactly. It has to be triggered this way.

Thanks,
Kirill

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
