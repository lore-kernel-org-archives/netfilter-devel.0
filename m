From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [HELP] why the string match does not work in nat tables?
Date: Mon, 31 Jan 2011 10:35:07 +0100
Message-ID: <4D46824B.2010706@netfilter.org>
References: <AANLkTinoBfMTDNVLHuBhMFJHHSrMmP0gwYTz2AX3f_ew@mail.gmail.com>	<alpine.LNX.2.01.1101310306560.15201@obet.zrqbmnf.qr>	<AANLkTik02D=agfFrc8VX+Wh4WAg_odm6cEcpbXvbgtqM@mail.gmail.com>	<alpine.LNX.2.01.1101310337270.19252@obet.zrqbmnf.qr> <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: JeHo Park <linuxpark@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <AANLkTikxZf8zMJxRTGg6BS4uc0PDus+E6cEtfLDQRTQu@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 31/01/11 03:47, JeHo Park wrote:
> hello jan
> i see, i took mistake. Ccs.. :-)
> anyway, i wonder why there is no TCP payload in the skb of the string
> or wurl match.

Because you only see the first packet of the flow in the NAT table.

You should use the string match in the filter or raw tables.
