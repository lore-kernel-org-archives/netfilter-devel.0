From: James Courtier-Dutton <James@superbug.co.uk>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Wed, 22 Sep 2004 12:52:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <41516764.8030205@superbug.co.uk>
References: <1095721742.5886.128.camel@bach>  <20040921143613.2dc78e2f.Ballarin.Marc@gmx.de> <1095803902.1942.211.camel@bach> <Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Marc Ballarin <Ballarin.Marc@gmx.de>,
	Linus Torvalds <torvalds@osdl.org>,
	netfilter-devel@lists.netfilter.org,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S264726AbUIVLwN@vger.kernel.org>
To: root@chaos.analogic.com
In-Reply-To: <Pine.LNX.4.53.0409220735080.2066@chaos.analogic.com>
List-Id: netfilter-devel.vger.kernel.org

Richard B. Johnson wrote:
> On Wed, 22 Sep 2004, Rusty Russell wrote:
> 
> 
>>On Tue, 2004-09-21 at 22:36, Marc Ballarin wrote:
>>
>>>On Tue, 21 Sep 2004 09:09:02 +1000
>>>"Rusty Russell (IBM)" <rusty@au1.ibm.com> wrote:
>>>
>>>
>>>>Name: Warn that ipchains and ipfwadm are going away
>>>>Status: Trivial
>>>>Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>>>
> What replaces the firewall stuff? It can't just "go away"!
> 
> Cheers,
> Dick Johnson

ipchains and ipfwadm are very old firewall implementations.
The current linux firewall code is called "iptables" and that has been 
present for a long time time, and that is staying.

So, the linux kernel still has firewall features, even with ipchains and 
ipfwadm removed.

James
