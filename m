From: Patrick McHardy <kaber@trash.net>
Subject: Re: ulogd large file support
Date: Tue, 19 Jun 2007 15:36:08 +0200
Message-ID: <4677DBC8.1090401@trash.net>
References: <20070619133053.GA27793@dreamhosted.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Andreas Lundin <lunde@dreamhosted.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070619133053.GA27793@dreamhosted.se>
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

Andreas Lundin wrote:
> ulogd seems to be missing large file support. Here is a simple patch
> to make configure handle it, but there is a line that is commented in
> Rules.make.in which will prevent the option to be used during compile
> time (search for @DEFS@ in Rules.make.in).
> 
> I compiled ulogd-1.24 with -D_FILE_OFFSET_BITS=64 and it can now write
> to log files larger than 2G on my system.


Applied, thanks. I've ran into this a couple of days ago with ulogd2,
so I've applied your patch there as well.
