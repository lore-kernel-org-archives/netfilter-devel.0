From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [connlimit] Revert 44bd4de9
Date: Mon, 14 Feb 2011 17:01:16 +0100
Message-ID: <4D5951CC.5030208@trash.net>
References: <4D594A8D.5040600@linux.vnet.ibm.com> <alpine.LNX.2.01.1102141644400.14613@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1102141644400.14613@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Am 14.02.2011 16:45, schrieb Jan Engelhardt:
> On Monday 2011-02-14 16:30, Stefan Berger wrote:
> 
>> I have to revert the early loop termination in connlimit since it generates
>> problems when an iptables statement does not use -m state --state NEW before
>> the connlimit match extension.
> 
> What problems? Why would xt_connlimit care about what other extensions 
> have been used before it?
> 

Because we abort once the threshold has been reached, which might be
before we found the matching connection and set addit to false.
