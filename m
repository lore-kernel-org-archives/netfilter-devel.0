From: Aaron Eppert <eppertan@cs.rose-hulman.edu>
Subject: libiptc and setsockopt
Date: Thu, 12 Dec 2002 16:23:34 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021212212334.GA2841@cs.rose-hulman.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


libiptc's iptc_commit(...) commit function appears to be
erroring out on rather valid data in the portion that 
does a setsockopt() on SO_SET_REPLACE.  The errno that is
set appears to be EAGAIN.  Can anyone shed a bit of light
on the situation as to why this may happen.  My application
is (unfortunately) using pthreads and all calls to libiptc
functions are wrapped with a mutex to prevent anyone from
calling into the library twice as I noticed it is hardly
thread safe.  

Thank you for your time,

Aaron Eppert
