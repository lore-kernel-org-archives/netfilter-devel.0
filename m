From: dukelion@mtv.kg
Subject: Some protection from DDOS with iptables.
Date: Thu, 10 Mar 2005 14:12:58 +0500
Message-ID: <200503101412.58339.dukelion@mtv.kg>
References: <200503081526.32310.scarab@echostar.pl> <423007AE.8030402@rhcs.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <423007AE.8030402@rhcs.de>
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

I need to block a kind of http requests, containing filenames zoo.jpg and 
zo2.jpg. These requests go from virus Bagle and hardly load our web server.

Rejecting or dropping these requests with string match isn't a solution, since 
it leaves unfinished connection with apache and it spawns hige number of 
threads in just a second.

Another try was to limit incoming connections. But it denies legal users from 
accessing our websites, and allowing virii to do it.

I'd like to have a rule closing connection on receiving certain string or met 
another condition. Is it possible with iptables?
