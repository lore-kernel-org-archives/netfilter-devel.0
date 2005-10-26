From: Phil Oester <kernel@linuxace.com>
Subject: Re: PPTP patch
Date: Wed, 26 Oct 2005 07:34:04 -0700
Message-ID: <20051026143404.GA12226@linuxace.com>
References: <01f701c5d9a1$f0fe8020$220ca8c0@columbuscontainer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John HIll <jhill@noach.com>
Content-Disposition: inline
In-Reply-To: <01f701c5d9a1$f0fe8020$220ca8c0@columbuscontainer.com>
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

On Tue, Oct 25, 2005 at 03:22:57PM -0500, John HIll wrote:
> 
> When I compile any kernel 2.6.11.x-2.6.12.x I get an error:
> ip_conntrack_pptp.ko needs unknown symbol __ip_conntrack_expect_find .
> 
> I searched all over Google and netfilter I found another person with the
> same problem but no replies.

Try using 2.6.14 when it is released (or use -rc5 if you prefer not to wait)

Phil
