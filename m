From: Patrick McHardy <kaber@trash.net>
Subject: Re: Verdict on deadlocks
Date: Fri, 23 Jul 2004 01:49:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41005276.10504@trash.net>
References: <20040721000931.GA3215@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040721000931.GA3215@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> Just a heads up that my gateways, which used to deadlock every 2-3 days are now
> stable, and have been running solidly for 2-3 weeks.  This is on 2.6.7, after
> applying two patches.  The first is already included in 2.6.8-rcx, and is
> the tcp-option bug described here:
> 
> http://www.netfilter.org/security/2004-06-30-2.6-tcpoption.html
> 
> The second is Patrick McHardy's FTP locking fix, documented here:
> 
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015719.html
> 
> Hopefully the FTP locking patch will be forwarded for inclusion in mainline
> soon.  Patrick?

There are a couple more places with the same problem. I'll prepare a
patch when I have some time, which will most likely be submitted.

Regards
Patrick

> 
> 
> Phil Oester
> 
