From: "D.J. Barrow" <barrow_dj@yahoo.com>
Subject: ipt_do_table infinite loop problem
Date: Wed, 25 Sep 2002 10:25:00 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020925172500.42916.qmail@web10411.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi All,
I am seeing a problem in mips32 little endian 
with iptables-1.2.5 linux-2.4.17 in ipt_do_table

the bug I am seeing is ipt_entry next offset is 0 & stays looping forever on
the same ipt_entry, I am not certain if it is a compiler bug
or a bug in ipt_do_table, if any of you have any opinions let me know.
My gdb debugger takes about 2 minutes to single step so I can't get too
familiar with the code.


I haven't seen the problem on mips big endian or intel linux.

I don't know the code well & the linked list,inlined macro 
hell that it is doesn't encourage me to get too familiar with it.

Here are some prinks of the problem.
table->name=mangle
e=c0007220 next_offset=152
e=c00072b8 next_offset=152
e=c0007350 next_offset=176
e=c0007400 next_offset=0

Unfortunately the mailing list is not searchable so I don't
know if I am reporting a duplicate bug either.

Thanks in advance



=====
D.J. Barrow Linux kernel developer
eMail: dj_barrow@ariasoft.ie 
Home: +353-22-47196.
Work: +353-91-758353

__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
