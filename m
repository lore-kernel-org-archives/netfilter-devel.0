From: iler_ml@fastmail.fm
Subject: handling the termination of 'expected' connection
Date: Tue, 31 Jan 2006 08:34:03 -0800
Message-ID: <1138725243.16037.253194510@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
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

Hello,

I am making the conntrack module similar to ip_conntrack_ftp.c, 
but additionally I need to track the termination (or expiry) of
the 'expected' connection.  Thus I need a callback from 
'ip_conntrack_core.c' when the 'expected' connection is terminated 
or expired. I think I need to patch 'ip_conntrack_core.c' for that ? 

Which points in 'ip_conntrack_core.c' are the right points to hook
for such event ? 

I though I would patch 'ip_conntrack_core.c' to call my callback when
struct ip_conntrack_core.c is deallocated. Does this sound right ?

Yakov Lerner
-- 
  
  iler_ml@fastmail.fm

-- 
http://www.fastmail.fm - The way an email service should be
