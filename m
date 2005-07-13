From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Proposed netmap patch
Date: Wed, 13 Jul 2005 12:49:46 +0200
Message-ID: <20050713104946.GE3215@eychenne.org>
References: <57F9959B46E0FA4D8BA88AEDFBE582909ED9@pxtbenexd01.pxt.primeexalia.com>
	<Pine.LNX.4.61.0507131231510.14635@yvahk01.tjqt.qr>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0507131231510.14635@yvahk01.tjqt.qr>
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

On Wed, Jul 13, 2005 at 12:32:51PM +0200, Jan Engelhardt wrote:

> >I had a need to use NETMAP but found it lacking the OUTPUT chain of the nat 
> >filter.  So I added it.  I have been running it for some time and it seems to 
> >work great.  Anyways, here is the patch that I used.  I found it useful.

> There must have been a reason why it was originally not allowed in the OUTPUT 
> chain, but I am not sure.

This has been discussed before:
http://lists.netfilter.org/pipermail/netfilter-devel/2005-April/019321.html

Conclusion: adding OUTPUT should be ok, but there seem to have been no
action so far.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
