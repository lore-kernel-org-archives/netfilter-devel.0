From: Phil Oester <kernel@linuxace.com>
Subject: Re: 3896 pom-ng broken
Date: Tue, 10 May 2005 08:43:54 -0700
Message-ID: <20050510154354.GB28833@linuxace.com>
References: <d5q4mb$fmo$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <d5q4mb$fmo$1@sea.gmane.org>
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

On Tue, May 10, 2005 at 12:15:19PM +0100, Amin Azez wrote:
> This change
> 
> http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/Netfilter_POM.pm?rev=3896&r1=3820&r2=3896
> 
> breaks pom-ng for me, such that it fails to apply most of the pom 
> patches because 2.6.11 seems to be the wrong source version.

Perhaps this was intentional...which specific patches don't work, and did you verify
the 'Requires' statement in the info file fits your kernel?

Phil
