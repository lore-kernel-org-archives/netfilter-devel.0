From: neo neo <neo_1979m@yahoo.com>
Subject: connlimit patch
Date: Fri, 12 Sep 2003 05:34:33 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912123433.97028.qmail@web21602.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-907459921-1063370073=:95574"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-907459921-1063370073=:95574
Content-Type: text/plain; charset=us-ascii

hi ,
       The connlimit patch by Gerd Knorr  uses the fuction ip_conntrack_find_get() defined in ipt_conntrack_core.c. But it seems  ip_conntrack_find_get is not getting exported - I get an 
   "unrsolved symbol - ip_conntrack_find_get" error when I try to insmod the module ipt_connlimit ( I use redhat linux 8.0).
       Is there any other way to get the  ipt_conntrack_tuple_hash from the given tuple?
 
nneop
 


---------------------------------
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
--0-907459921-1063370073=:95574
Content-Type: text/html; charset=us-ascii

<DIV>hi ,</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; The connlimit patch by Gerd Knorr&nbsp; uses the fuction ip_conntrack_find_get() defined in ipt_conntrack_core.c. But it seems&nbsp; ip_conntrack_find_get is not getting exported - I get an </DIV>
<DIV>&nbsp;&nbsp; "unrsolved symbol - ip_conntrack_find_get" error when I try to insmod the module&nbsp;ipt_connlimit ( I use redhat linux 8.0).</DIV>
<DIV>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Is there any other way to get the&nbsp; ipt_conntrack_tuple_hash from the given tuple?</DIV>
<DIV>&nbsp;</DIV>
<DIV>nneop</DIV>
<DIV>&nbsp;</DIV><p><hr SIZE=1>
Do you Yahoo!?<br>
<a href="http://us.rd.yahoo.com/evt=10469/*http://sitebuilder.yahoo.com">Yahoo! SiteBuilder</a> - Free, easy-to-use web site design software
--0-907459921-1063370073=:95574--
