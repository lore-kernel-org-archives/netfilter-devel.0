From: Scott MacKay <scottmackay@yahoo.com>
Subject: iptables extensions
Date: Wed, 16 Apr 2003 11:14:04 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030416181404.54392.qmail@web13906.mail.yahoo.com>
References: <20030416180232.15493.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030416180232.15493.qmail@web13907.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hiyas,
   I don't know if there is a 'request' area for
development or not, but would there be any way to get
a new function added to the extensions library?  While
printing the field (->print()) is yippie skippie, I
would really like it of the string representation of
the field could be dumped into a character buffer,
maybe using a function like: 
static const void sprint(const struct ipt_ip
*ip,ipt_entry_match *match, char *sbuffer, int
sbuffer_len);
Basically would do what print() does, but dump the
results into a character buffer, to examine/deliver in
a means other than printf().  

-Scott

__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com
