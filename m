From: "Toby DiPasquale" <codeslinger@gmail.com>
Subject: svn.netfilter.org having problems?
Date: Sun, 5 Mar 2006 12:07:53 -0500
Message-ID: <876ef97a0603050907l23f4015dx97e0b349fca19ece@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: nf-devel <netfilter-devel@lists.netfilter.org>
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

Here's what I get when I go to
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk

<output>
An Exception Has Occurred
Python Traceback

Traceback (most recent call last):
  File "/var/www/localhost/viewcvs/lib/viewcvs.py", line 3283, in main
    request.run_viewcvs()
  File "/var/www/localhost/viewcvs/lib/viewcvs.py", line 262, in run_viewcv=
s
    import vclib.svn
  File "/var/www/localhost/viewcvs/lib/vclib/svn/__init__.py", line 28, in =
?
    from svn import fs, repos, core, delta
  File "/usr/lib/python2.4/site-packages/svn/fs.py", line 19, in ?
    from libsvn.fs import *
  File "/usr/lib/python2.4/site-packages/libsvn/fs.py", line 5, in ?
    import _fs
ImportError: libswigpy.so.0: cannot open shared object file: No such
file or directory

</output>

Is there maintenance ongoing right now?

--
Toby DiPasquale
0x636f6465736c696e67657240676d61696c2e636f6d
