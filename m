From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [TYPO] patch to cvs libipt_string.c
Date: 03 May 2003 21:48:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051991325.3827.54.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0304281524370.22672-100000@blimp.psdhost.net>
	 <20030430160134.GF685@sunbeam.de.gnumonks.org>
	 <1051757639.4728.172.camel@scotty.cafe.5gnetworks.com>
	 <20030501112738.GD26924@sunbeam.de.gnumonks.org>
	 <1051835360.7001.5.camel@scotty.cafe.5gnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Oscar Fudd <ofudd@speed-test.net>
In-Reply-To: <1051835360.7001.5.camel@scotty.cafe.5gnetworks.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-05-02 at 02:29, Oscar Fudd wrote:
> On Thu, 2003-05-01 at 04:27, Harald Welte wrote:
> > On Wed, Apr 30, 2003 at 07:53:59PM -0700, Oscar Fudd wrote:
> > > Also, patch-o-matic says to not use this module with linux kernel 2.4.9.
> > > Does it work with kernels after 2.4.9?  It looks like it does; could the
> > > patch-o-matic help message be changed to say so?  I've been avoiding
> > > this module because of that message...  :-)
> > 
> > but your suggested message is wrong.  The statement is quite valid.  It
> > both works with kernels <= 2.4.8 and kernels >= 2.4.10
> > 
> > > Oscar Fudd <ofudd@speed-test.net>
> 
> Ok, fine, my suggested message is wrong.  However, the original message
> isn't clear, which makes it at least as wrong.
> 
> With other projects, a message like that would mean that it broke in
> 2.4.9 and hasn't been fixed since.

Well, that message can be removed, we don't support kernel < 2.4.18
anyway.

-- 
/Martin
