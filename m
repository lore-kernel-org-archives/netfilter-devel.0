From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: How to download POM-ng these days?
Date: Wed, 28 Dec 2005 11:13:19 +0100
Message-ID: <200512281113.19261@nienna>
References: <925A849792280C4E80C5461017A4B8A26D2F@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Greg Scott <GregScott@infrasupportetc.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <925A849792280C4E80C5461017A4B8A26D2F@mail733.InfraSupportEtc.com>
Content-Disposition: inline
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


  Hi,

On Wednesday 28 December 2005 08.25, Greg Scott wrote:
> I am trying to incorporate several POM patches, including some of the
> contrack-nat helpers, ipsec, and some others.  None of the techniques
> documented in the main netfilter website work anymore.  I scoured the
> netfilter-devel list archives and found a reference to this website:
>
> https://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/
>
> I am looking at it now and I see references to all the POM modules of
> interest, along with a bunch of LDAP stuff about each module and
> references to thousands of build versions.  But I am hopelessly confused
> as to how to download the most up to date builds of everything and get
> them into a form that the runme script can use.  Or is the runme script
> also now obsolete and if so, what is the best way to download and apply
> the POM patches of interest?  If anyone would be willing to hold my hand
> a little bit, I will document how it's done currently and post it to the
> list.

  You have basically two possibilities:

  * either you "check out" the current version using Subversion
    (<http://subversion.tigris.org>)
    (<http://www.netfilter.org/downloads.html#svn>)

  * or you download the latest daily snapshot from the Netfilter FTP server
    (<ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot>)

-- 
KOVACS Krisztian
