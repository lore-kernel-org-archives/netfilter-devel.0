From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: libxt_TCPOPTSTRIP(iptables) 20071014
Date: Tue, 16 Oct 2007 16:48:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710161648090.10197@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710141622170.22801@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710141714420.6777@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55660 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbXJPOsd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:48:33 -0400
In-Reply-To: <Pine.LNX.4.64.0710141714420.6777@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 14 2007 17:19, Krzysztof Oledzki wrote:
> On Sun, 14 Oct 2007, Jan Engelhardt wrote:
>
>> +static const struct tcp_optionmap tcp_optionmap[] = {
>> +	{"wscale",         "Window scale",         TCPOPT_WINDOW},
>> +	{"mss",            "Maximum Segment Size", TCPOPT_MAXSEG},
>> +	{"sack-permitted", "SACK permitted",       TCPOPT_SACK_PERMITTED},
>> +	{"sack",           "Selective ACK",        TCPOPT_SACK},
>> +	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
>> +	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
>> +	{NULL},
>> +};
>
> Ahh, good. Thank you for considering my suggestions.
>
> Just cosmetic: what about making it up to
> http://www.iana.org/assignments/tcp-parameters:
>
> s/Window scale/Window Scale/
> s/SACK permitted/SACK Permitted/
> s/MD5 signature/MD5 Signature/

I think there is a limit to pedantry :)
