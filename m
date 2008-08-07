From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack -L shows an entry, conntrack -G doesn't
Date: Thu, 07 Aug 2008 10:36:13 +0200
Message-ID: <489AB3FD.5010206@netfilter.org>
References: <55990.80.98.202.103.1218034911.squirrel@hippy.csoma.elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: synapse@hippy.csoma.elte.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49395 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751738AbYHGIgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Aug 2008 04:36:31 -0400
In-Reply-To: <55990.80.98.202.103.1218034911.squirrel@hippy.csoma.elte.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

synapse@hippy.csoma.elte.hu wrote:
> root@test:~# conntrack -L -s 192.168.13.12 -q 192.168.13.12 -p tcp
> --orig-port-src
> 49939 --reply-port-src 12345
>     tcp      6 431950 ESTABLISHED src=192.168.13.12 dst=217.20.131.2
> sport=49939
> dport=22 packets=2 bytes=112 src=127.0.0.1
>     dst=192.168.13.12     sport=12345 dport=49939 packets=1 bytes=60
> [ASSURED]
> mark=0 use=1
> 
> root@test:~# conntrack -G -s 192.168.13.12 -q 192.168.13.12 -p tcp
> --orig-port-src
> 49939 --reply-port-src 12345
>     Operation failed: such conntrack doesn't exist

My git snapshot fails as there are missing parameters:
conntrack v0.9.7: missing IP address
Try `conntrack -h' or 'conntrack --help' for more information.

> The redirection is done as:
> 
>     iptables -t nat -F
>     iptables -t nat -X
>     iptables -t nat -Z
> 
>     iptables -t nat -A OUTPUT -p tcp --destination-port 22 -j REDIRECT
> --to-ports 1234
> 
> I am using the latest ubuntu btw (upgraded fully), with versions:
>     conntrack                           1.00~beta2-1

This version is very old. The conntrack package was superseded by the
conntrack-tools. Please, check http://conntrack-tools.netfilter.org to
get the latest.

> Basically I am clueless here as to why -L shows the connection and -G
> doesn't. My goal is to
> transparently proxy outgoing connections through my program. Therefore I
> need to detect
> what its' original destination would be from the information seen by the
> program on
> 12345.

As for now, the -G command requires the tuple {source, destination,
source port, destination port, protocol}.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
