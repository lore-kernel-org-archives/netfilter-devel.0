From: Herve Eychenne <rv@wallfire.org>
Subject: Re: nf_conntrack & NAT
Date: Wed, 23 Nov 2005 14:20:45 +0100
Message-ID: <20051123132044.GZ3249@eychenne.org>
References: <Pine.LNX.4.64.0511231214590.11295@bizon.gios.gov.pl>
	<200511231225.jANCPmYd015427@toshiba.co.jp>
Reply-To: rv@wallfire.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200511231225.jANCPmYd015427@toshiba.co.jp>
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

On Wed, Nov 23, 2005 at 09:25:47PM +0900, Yasuyuki KOZAKAI wrote:

 Hi,

> >                                                      and adding NAT 
> > support for IPv6?

> Never ever. You can learn why people don't want to do it from many sources.
> For example, You can use many addresses in IPv6 world. And I don't want people
> get troubles due to NAT traversal issues in IPv6 world.

And what if you want your firewall to transparently redirect some traffic
to another host, for example?

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
