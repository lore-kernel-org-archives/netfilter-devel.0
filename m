From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: local NAT
Date: Wed, 11 Jun 2003 16:03:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030611140313.GB8055@balabit.hu>
References: <20030607215013.4F9B8444E8@service.i-think-future.de> <20030611120649.GK32593@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Nils Radtke <Nils.Radtke@Think-Future.de>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030611120649.GK32593@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 11, 2003 at 02:06:49PM +0200, Harald Welte wrote:
> On Sat, Jun 07, 2003 at 11:50:04PM +0200, Nils Radtke wrote:
> >   Question:
> >   Is there code around implementing the feature of SNATting incoming
> >   packets for local processes?
> 
> not that I am aware of.  And I can still not imagine a setup where this
> would make any sense.  Please enlighten me.

a security proxy analyzing HTTP requests before the real webserver gets its
hand on it. if you want the webserver to get the original client as the
source of the connection you need something like this.

using an application proxy on the same host as the webserver has the
following benefits:

1) protocol sanitization

2) completely separate jails for separate users of the same box, e.g. you
   have a dozen webservers, each running in different chroot under different
   uid, the proxy choosing the appropriate local webserver based on the Host
   header of the HTTP request.

3) separate webservers for WebDAV like requests (where the webserver needs
   write permissions to the webroot) and usual HTTP requests (where it is
   read only access is enough)

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
