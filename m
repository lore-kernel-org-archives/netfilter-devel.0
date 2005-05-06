From: =?iso-8859-1?b?Svhybg==?= Andre Nese Berntzen <jornandr@stud.ntnu.no>
Subject: libipq, open sockets stalling the app
Date: Fri,  6 May 2005 16:29:09 +0200
Message-ID: <1115389749.427b7f3511965@webmail.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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

Hi!

I'm using libipq and ip_queue with the QUEUE target to
redirect packages. Basically I intercept the packages,
rewrite the destination IP and ACCEPT the package.

My question is, during the running of the app
'lsof | grep root' show theres building up open sockets
to the resource limit and then the app stops working.
I havent been able to pinpoint the problem but it seems
like its in libipq.

Does anyone know what this is? Am I missing out on the code
somewhere and have a loose end maybe?

J=F8rn Andre
