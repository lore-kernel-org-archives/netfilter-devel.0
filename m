From: =?iso-8859-1?q?Jambunathan=20Kalyanasundaram?= <k_jambunathan@yahoo.co.uk>
Subject: Dynamic rule creation and deletion
Date: Wed, 25 Feb 2004 17:18:42 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225171842.54119.qmail@web25105.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Just to give context to my query ...

Transparent http proxy is at times required to talk to
the origin web server with it's own ip address spoofed
to that of the browser for which it is forwarding the
request.

This requirement can be implemented though a SNAT rule
that translates the source ip address of the outgoing
packet to the browser's ip address.

Before the tproxy sends out a SYN to the to the web
server the 4-tuple needs to be noted so that even the
SYN packet gets spoofed. This can be realised by doing
a non-wildcard bind() before doing the connect(). This
way the 4-tuple would be available in advance and the
following SNAT rule can be created on the tproxy box

iptables -A POSTROUTING -t nat -s <local ip> -d <web
server ip> -p tcp --sport <local port> --dport 80 -j
SNAT --to <browser ip>

Problem (1): The above rule should be created on the
fly through programmatic invocation as the all the
translation info is available only at run time.

Can I use iptc_append-entry() with a suitbale
ipt_entry ( just the same as iptables would have
created for the above command ) suffices to create the
above rule in kernel. I have looked the libiptc doc
and is not clear whether this could indeed be done.

Are there any helper functions to fill out the boring,
monolithic ipt_entry ( with tcp match and SNAT target
)

Problem (2): The above rule needs to be deleted on the
fly once the connection tears down. This should not be
through a programmatic invocation. Because it's
possible that the deletion thread is put to sleep and
the deletion wwould actually take effect *much after*
the connection is torn down. In which case, it can
potentially interfere with the reincarnation of the
same tuple. Ofcourse 2MSL time out may help us not see
this issue if the connection progresses gracefully all
the way to an elegant close but what if the connection
is ungracefully torn with a RST.


Please let me know how you think probelm 1 and problem
2 be addressed. 

ps: I had done a similar posting yesterday but I don't
see my posting in the archives. Just sending the same
query again with good amount of rephrase.

Thanks in advance,
Jambunathan K.






	
	
		
___________________________________________________________
Yahoo! Messenger - Communicate instantly..."Ping" 
your friends today! Download Messenger Now 
http://uk.messenger.yahoo.com/download/index.html
