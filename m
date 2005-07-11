From: Amin Azez <azez@ufomechanic.net>
Subject: NETLINK_NETFILTER and NETLINK_FIB_LOOKUP
Date: Mon, 11 Jul 2005 12:34:24 +0100
Message-ID: <42D25940.4050000@ufomechanic.net>
References: <42C03F2E.30706@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42C03F2E.30706@eurodev.net>
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


2.6-git defines

#define NETLINK_FIB_LOOKUP      10

which conflicts with

#define NETLINK_NETFILTER     10      /* netfilter subsystem */



Are we going to have to change number again?

Should we push this definition upstream just to get a fixed number
reserved? I don't think netfilter is going away any time soon.

Azez
