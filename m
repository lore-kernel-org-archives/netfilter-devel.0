From: Oscar Fudd <ofudd@speed-test.net>
Subject: Re: [TYPO] patch to cvs libipt_string.c
Date: 30 Apr 2003 19:53:59 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051757639.4728.172.camel@scotty.cafe.5gnetworks.com>
References: <Pine.LNX.4.44.0304281524370.22672-100000@blimp.psdhost.net>
	 <20030430160134.GF685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030430160134.GF685@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Also, patch-o-matic says to not use this module with linux kernel 2.4.9.
Does it work with kernels after 2.4.9?  It looks like it does; could the
patch-o-matic help message be changed to say so?  I've been avoiding
this module because of that message...  :-)
  
http://cvs.netfilter.org/netfilter/patch-o-matic/extra/string.patch.help?rev=1.3&content-type=text/x-cvsweb-markup

-THIS PATCH DOES NOT WORK WITH KERNEL 2.4.9 !!!
+THIS PATCH DOES NOT WORK WITH KERNEL 2.4.9 OR OLDER !!!

On Wed, 2003-04-30 at 09:01, Harald Welte wrote:
> On Mon, Apr 28, 2003 at 03:29:31PM -0700, ofudd@psdhost.net wrote:
> > Hi!
> > 
> > I downloaded iptables from CVS today, enabled the string matching
> > feature, and tried to compile the userspace tools.  Compilation failed
> > due to a typo.
> > 
> > In ./netfilter/userspace/extensions/libipt_string.c:
> 
> This is bugzilla bug 89, which has been fixed now.
> 
> > ofudd@psdhost.net
-- 
Oscar Fudd <ofudd@speed-test.net>
