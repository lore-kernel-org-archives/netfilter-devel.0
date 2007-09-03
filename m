From: Thomas Graf <tgraf@suug.ch>
Subject: Re: netfilter support in libnl
Date: Mon, 3 Sep 2007 11:59:15 +0200
Message-ID: <20070903095915.GF18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DBD453.5040505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DBD453.5040505@trash.net>
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

* Patrick McHardy <kaber@trash.net> 2007-09-03 11:30
> Philip Craig wrote:
> > There have been comments in the past on this list about using libnl
> > for the netfilter netlink support, and since I would like to use a
> > common library api for all the netlink interfaces, I decided to give
> > it a go.  These patches are the result of that.
> > 
> > Any comments welcome, particularly about whether this is still
> > something that is desired.
> 
> 
> Very nice, I think its still desirable to avoid having to
> use multiple pretty similar libraries in case you also need
> to use other netlink subsystems.

I agree, it would be great if we could get rid of the almost
duplicate effort of nfnl attributes etc.

> And I think LGPL is a much better choice than GPL for stuff
> like this.

This is my fault, I intedend to use LGPL as stated in the COPYING
for some brain dead reason have been copying GPL headers from file
to file. I'm fixing this up right now.

> If you want to merge this upstream, you should probably CC
> Thomas.
