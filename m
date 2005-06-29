From: Herve Eychenne <rv@wallfire.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Wed, 29 Jun 2005 18:09:23 +0200
Message-ID: <20050629160923.GF3331@eychenne.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20050629154049.GA17717@oknodo.bof.de>
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

On Wed, Jun 29, 2005 at 05:40:49PM +0200, Patrick Schaaf wrote:

> > My question is, if anyone sees any problems with this, regarding performance
> > degradation on 32bit boxes or with caching problems?

> The problem is compatibility with older versions of the LOG target,
> both Userlevel (iptables .so module), and Kernel.

> You can either make this a new target, or look how the versioning
> infrastructure discussed here some months ago, worked out. (I don't
> know; maybe there's already a HOWTO, or you want to write one :)

I remember saying here that it would be cool to have the log prefix length
tunable at kernel LOG module insertion, have it exported (read-only) to some
/proc entry, and have userspace (iptables, or any other upper-level
application) rely on the real-time extracted value.
What do you think?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
