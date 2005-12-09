From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: SVN web problems?
Date: Sat, 10 Dec 2005 00:13:31 +0300
Message-ID: <20051209211331.GA2897@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, PatriK McHardy <kaber@trash.net>
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

I've just read bugzilla about OSF module and found, that it's 2.4
version does not support connector option, so I decided to download
header file [URL:
http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h?view=markup], 
but failed with the following error:

An Exception Has Occurred

trunk/patch-o-matic-ng/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h:
unknown location

HTTP Response Status

404 Not Found

Python Traceback

Traceback (most recent call last):
  File "/var/www/localhost/viewcvs/lib/viewcvs.py", line 3283, in main
      request.run_viewcvs()
        File "/var/www/localhost/viewcvs/lib/viewcvs.py", line 297, in
	run_viewcvs
	    % self.where, '404 Not Found')
	    ViewCVSException: 404 Not Found:
	    trunk/patch-o-matic-ng/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h:
	    unknown location



-- 
	Evgeniy Polyakov
