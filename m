From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] document multiport invert option
Date: Thu, 9 Sep 2004 15:36:56 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040909133656.GA3158@eychenne.org>
References: <20040908233535.GA17162@linuxace.com>
	<1094724443.8900.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1094724443.8900.2.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 09, 2004 at 12:07:23PM +0200, Martin Josefsson wrote:

> On Thu, 2004-09-09 at 01:35, Phil Oester wrote:
> > The man/-h pages for multiport don't document that you can use
> > inversion.  This can be confusing, since multiport uses '! --port x'
> > instead of '--dport ! x' like tcp/udp.
> > 
> > This closes bugzilla #143

> I believe neither multiport or mport has invert support, they don't
> complain when you add a inverted rule but the resulting rule won't be
> inverted so I'm not going to apply this patch.

Though, multiport and mport should have invert support, right?
So you may add this support to your patch, phil. :-)

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
