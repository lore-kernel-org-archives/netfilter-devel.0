From: "David Vogt" <beunlovable@gmail.com>
Subject: Multiple programs for QUEUE target
Date: Tue, 4 Apr 2006 15:55:11 +0200
Message-ID: <859616420604040655h6312ac86g3c8661c29bf4c7e5@mail.gmail.com>
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

Dear all,

as far as I understand libipq it is not possible to register more than
one program that handles packets that are queued (using -j QUEUE),
since only one pid can be registered at /proc/net/ip_queue. Is that
right?

Now I have two questions:
1) Does libnetfilter_queue solve that problem
2) Will packets be processed by both applications?

The problem is that I use a closed source program here as well, that
employs libipq. Altough I could rewrite my own application to use
libnetfiter_queue I would highly appreciate a solution that uses
libipq. I am sure I read something about a "dispachter"-like program,
but I can't find it.

Thanks,
David
