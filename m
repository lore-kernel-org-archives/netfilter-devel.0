From: "Steve Ashley" <sashley@bsafeonline.com>
Subject: libipq question
Date: Fri, 25 Jun 2004 15:12:27 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <A516FD6F11040F4E881C92EDA23F31A802ACF8AE@mx1.bsafeonline.com>
Reply-To: <spanishmack@mchsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello all,

I'm using libipq to do some user-space filter stuff.  Everything is
working great and for my application, I'm not taking a significant
enough speed hit to warrant making a new target, iptables kernel module.
However, I am getting one problem.  If my application runs for a long
time ( i.e. several hours or overnight ) with no activity, then filters
packets.  I'm getting the following error messages:

Error in recv().
Broken pipe.

Then the application exits.

I assume this is probably concerning the underlying netlink socket.  How
can I go about catching / trapping this condition?  For some errors, I
can simply destroy my ipq_handle and get a new one and keep going.

Currently I'm using the blocking version of the ipq_read() function,
with no timeout.  Would putting a timeout here, and checking on the
netlink socket every so often be a good idea?  Any thoughts or ideas
would be helpful.

Also, just for information sake.  At some point, if I add more features
into my application, I fear using a userspace application may not be
sufficient.  Where can I find a good example of a new netfilter target
kernel module code?  The most I've ever done in the kernel was to make a
"hello world" kernel module, so any help here would be greatly
appreciated.


Stephen Ashley
Ashley Professional Services, Inc. P.A.
spanishmack@mchsi.com
