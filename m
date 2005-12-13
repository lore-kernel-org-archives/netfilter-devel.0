From: Toby DiPasquale <codeslinger@gmail.com>
Subject: Re: POMNG patch: "rope" - scriptable match module
Date: Mon, 12 Dec 2005 19:31:03 -0500
Message-ID: <876ef97a0512121631i6541a8adh838a65f5963b959@mail.gmail.com>
References: <439E0CB3.1020202@lowth.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Chris Lowth <chris@lowth.com>
In-Reply-To: <439E0CB3.1020202@lowth.com>
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

On 12/12/05, Chris Lowth <chris@lowth.com> wrote:
> I'd like to submit the "rope" match module to the team for consideration
> for inclusion in patch-o-matic-ng.
...
> Current limitations..
>     Works with version 2.4.x kernels - version 2.6 support is coming.
>     Doesnt work with SMP kernels - that too is coming.

Why would you submit this to the POM team when it doesn't work on
2.6.x or SMP and 2.4.x is in maintenance mode? I've been tracking your
module for some time and these limitations have persisted. (I
personally have rejected it several times in my own work because of
them) I'm curious: do you think the POM team will fix them for you?

--
Toby DiPasquale
0x636f6465736c696e67657240676d61696c2e636f6d
