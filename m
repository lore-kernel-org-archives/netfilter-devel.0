From: James Courtier-Dutton <james.dutton@gmail.com>
Subject: Number of forwarding tables.
Date: Mon, 10 Oct 2005 10:53:27 +0100
Message-ID: <ad2655cb0510100253s5da6654i@mail.gmail.com>
Reply-To: James Courtier-Dutton <james.dutton@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

The linux kernel seems to support 255 forwarding tables.
Is there any way to expand this?
For example, in order to support more than 255 Virtual Routers (e.g.
1000), with each router only having a few routes in it.

Is this a hard limit, or something I can change by modifying a define
statement in the kernel source?

James
