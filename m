From: Patrick McHardy <kaber@trash.net>
Subject: Re: 3896 pom-ng broken
Date: Tue, 17 May 2005 17:05:46 +0200
Message-ID: <428A084A.3040606@trash.net>
References: <d5q4mb$fmo$1@sea.gmane.org>
	<20050510154354.GB28833@linuxace.com>	<4280DBB3.9070905@ufomechanic.net>	<debc30fc0505101214699d85b8@mail.gmail.com>	<debc30fc050510121564dd0703@mail.gmail.com>
	<20050511005121.GA31199@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050511005121.GA31199@linuxace.com>
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

Phil Oester wrote:
> Indeed, my patch was broken.  But the 'Requires' handling is also broken, but
> will take something nontrivial to fix.
> 
> In the interim, the below patch reverts my changes, and adds a necessary
> 2nd Requires to pptp.  Harald, please apply.

Applied, thanks Phil.
