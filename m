From: Scott MacKay <scottmackay@yahoo.com>
Subject: Updating a modular ip_queue
Date: Mon, 1 Mar 2004 13:00:46 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040301210046.74474.qmail@web13903.mail.yahoo.com>
References: <404355FF.5010305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <404355FF.5010305@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
    I would like to pass back more info to a userspace
ip_queue target than the current ipq_packet_msg
allows.  My thought was to add on the fields I wanted
to the structure.  A few quick greps and it appears
the only one who use a ipq_packet_msg in the kernel is
the ip_queue source file.  Optionally, if there is a
good method of passing session info already, that
would be good to know.
I plan to build ip_queue in module format and compile
the libraries by hand (so the libs get the full
ip_packet_msg definition).  On doing this, do I really
need to anything to the distributed kernel other than
copy the ip_queue.o object file into the /lib area?  

__________________________________
Do you Yahoo!?
Get better spam protection with Yahoo! Mail.
http://antispam.yahoo.com/tools
