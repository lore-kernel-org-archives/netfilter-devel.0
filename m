From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Thu, 21 Apr 2005 03:41:58 +0200
Message-ID: <426704E6.5050703@trash.net>
References: <4250FA72.3020502@trash.net>
	<20050404204716.GA4067@linuxace.com>	<20050406044806.GA9711@linuxace.com>
	<4263108E.1030707@trash.net>	<20050419005847.GA591@linuxace.com>
	<42666F4C.5080706@trash.net>	<20050420155308.GA7057@linuxace.com>
	<42667E51.3060005@trash.net>	<20050420172406.GB7057@linuxace.com>
	<42669674.3020905@trash.net>
	<20050420182505.GA7612@linuxace.com> <4266CC05.5040103@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <4266CC05.5040103@rtij.nl>
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

Martijn Lievaart wrote:
> Some Windows graphical FTP frontends do multiple transfers. I think one 
> should take these into account. OTOH, how often do PORT commands arrive 
> out of sequence even given that it is possible?

These clients most likely open up multiple control connections.
But it doesn't really matter, this function is not directly related
to FTP and it needs to work properly in all cases.

Regards
Patrick
