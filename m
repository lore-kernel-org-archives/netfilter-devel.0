From: Phil Oester <kernel@linuxace.com>
Subject: cvs.netfilter.org down
Date: Thu, 11 Nov 2004 18:08:41 -0800
Message-ID: <20041112020841.GA26810@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I get this error on the site:

Traceback (most recent call last):
  File "/var/www/localhost/viewcvs/lib/viewcvs.py", line 3194, in main
    request.run_viewcvs()
  File "/var/www/localhost/viewcvs/lib/viewcvs.py", line 264, in run_viewcvs
    self.rootpath, rev)
  File "/var/www/localhost/viewcvs/lib/vclib/svn/__init__.py", line 322, in __init__
    self.repos = repos.svn_repos_open(rootpath, self.pool)
SubversionException: ("Berkeley DB error while opening 'revisions' table for filesystem /data/svn/netfilter.org/netfilter/db:\nCannot allocate memory", 160029)


Phil
