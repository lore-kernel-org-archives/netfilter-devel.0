From: Phil Oester <kernel@linuxace.com>
Subject: Re: ipt_unclean query
Date: Sat, 8 Apr 2006 09:44:42 -0700
Message-ID: <20060408164442.GA20209@linuxace.com>
References: <44376F11.4000804@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sumit <sumit@elitecore.com>
Content-Disposition: inline
In-Reply-To: <44376F11.4000804@elitecore.com>
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

On Sat, Apr 08, 2006 at 01:36:41PM +0530, Sumit wrote:
> Hi Devs,
> 	After making an unclean DROP ruleset I got "not-working" complains 
> 	form some of my clients who using specific stock-trading application.

Unclean is unsafe, and is scheduled to be removed from pom within the
next 30 days.  Don't use it.

Phil
