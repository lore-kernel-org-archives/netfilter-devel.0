From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: [PATCH] Re: RV: Problems installing Netfilter extensions
Date: Sun, 22 Jun 2003 03:59:07 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306220359.08038.fabrice@netfilter.org>
References: <000901c336e7$bb9b5390$0300000a@juan> <1056101793.633.15.camel@exile>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1056101793.633.15.camel@exile>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

On Friday 20 June 2003 17:36, Filip Sneppe (Cronos) wrote:
> On Fri, 2003-06-20 at 06:52, Juan Torres wrote:
> make all install
> > This last step doesn't work!! When I execute this command in the
> > userspace/ subdirectory inside the patch-o-matic directory, It appears
> > an error saying that It can't find the "all" option (or something
> > similar), I have proved to do "make all" and "make install", but it
> > doesn't work anyway
> > What I'm not doing properly??
> Hi Juan,
> There appears to be an error in the Netfilter extensions HOWTO.
> As you can see from the INSTALL file in the userspace directory,
> there is no "make all", only a "make" to build the binaries.
> I think the patch below updates the documentation to reflect
> this. Thanks for pointing this out.

Thanks for the patch. I just applied it.

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
