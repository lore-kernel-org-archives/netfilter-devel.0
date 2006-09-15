From: Patrick McHardy <kaber@trash.net>
Subject: Re: svn.netfilter.org and patch-o-matic-ng snapshots broken?
Date: Fri, 15 Sep 2006 06:38:36 +0200
Message-ID: <450A2E4C.5000601@trash.net>
References: <edsck3$2tg$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Danny Rathjens <gmane@rathjens.org>
In-Reply-To: <edsck3$2tg$1@sea.gmane.org>
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

Danny Rathjens wrote:
> % svn co http://svn.netfilter.org/netfilter/trunk/iptables
> svn: REPORT request failed on '/netfilter/!svn/vcc/default'
> svn: Can't find a temporary directory
> 
> % ncftp ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/
> [...]
> ncftp > ls -latr
> [...]
> -rw-r--r--   1 ftpuser  ftpgroup   142539 Sep  2 21:55
> patch-o-matic-ng-20060902.tar.bz2
> -rw-r--r--   1 ftpuser  ftpgroup       68 Sep  2 21:55
> patch-o-matic-ng-20060902.tar.bz2.md5sum
> -rw-r--r--   1 ftpuser  ftpgroup       46 Sep  3 21:55
> patch-o-matic-ng-20060903.tar.bz2
> -rw-r--r--   1 ftpuser  ftpgroup       68 Sep  3 21:55
> patch-o-matic-ng-20060903.tar.bz2.md5sum
> -rw-r--r--   1 ftpuser  ftpgroup       46 Sep  4 21:55
> patch-o-matic-ng-20060904.tar.bz2
> -rw-r--r--   1 ftpuser  ftpgroup       68 Sep  4 21:55
> patch-o-matic-ng-20060904.tar.bz2.md5sum
> -rw-r--r--   1 ftpuser  ftpgroup       46 Sep  5 21:55
> patch-o-matic-ng-20060905.tar.bz2
> -rw-r--r--   1 ftpuser  ftpgroup       68 Sep  5 21:55
> patch-o-matic-ng-20060905.tar.bz2.md5sum
> -rw-r--r--   1 ftpuser  ftpgroup       46 Sep  6 21:55
> patch-o-matic-ng-20060906.tar.bz2
> -rw-r--r--   1 ftpuser  ftpgroup       68 Sep  6 21:55
> patch-o-matic-ng-20060906.tar.bz2.md5sum
> drwxrwxr-x   2 ftpuser  ftpgroup    40960 Sep  7 21:55 .
> -rw-r--r--   1 ftpuser  ftpgroup       46 Sep  7 21:55
> patch-o-matic-ng-20060907.tar.bz2
> -rw-r--r--   1 ftpuser  ftpgroup       68 Sep  7 21:55
> patch-o-matic-ng-20060907.tar.bz2.md5sum


Apparently there were some problems (the list was dead for a
couple of days too), but its working again.
