From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: kernel crash
Date: 30 May 2003 00:36:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1054247760.709.94.camel@tux.rsn.bth.se>
References: <3ED67067.6080605@eburg.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gordon Messmer <yinyang@eburg.com>
In-Reply-To: <3ED67067.6080605@eburg.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-05-29 at 22:41, Gordon Messmer wrote:
> We recently have had trouble with kernel crashes on a Linux 2.4.20 box 
> used as a NAT gateway.  The machine is running Slackware 8.1 with a 
> vanilla 2.4.20 kernel.  The kernel configuration is attached.  The 
> message-log attachment contains the full dmesg output, as captured by a 
> remote syslog server, as well as the last messages received before the 
> box hung:
> 
> May 28 16:18:08 tog-wakko4 kernel: LIST_DELETE: ip_conntrack_core.c:303 
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f687fbc4) not in &ip_conntrack_hash 
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> May 28 16:18:52 tog-wakko4 kernel: LIST_DELETE: ip_conntrack_core.c:303 
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f687cd24) not in &ip_conntrack_hash 
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> May 28 16:18:52 tog-wakko4 kernel: LIST_DELETE: ip_conntrack_core.c:303 
> `&ct->tuplehash[IP_CT_DIR_REPLY]'(f687ce64) not in &ip_conntrack_hash 
> [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)].
> 
> What further information would be useful in tracking down this problem?

Beware that conntrack in kernel 2.4.20 has a serious bug caused by core
kernel changes. Can you please try 2.4.21-rc or apply at least
submitted/10_confirm_fix.patch from patch-o-matic and run the same thing
again and see if it still happens?

It appears that as if the reply-tuple is modified after the conntrack
has been added to the hashtable (shouldn't happen). The only place this
modification could happen is in ip_conntrack_alter_reply() which is
called from ip_nat_setup_info() which in turn is called from various
places to set up NAT mappings. But I can't find a place where it's
called for a connection that's already in the hashtable...
And the IP_NF_ASSERT() in ip_conntrack_alter_reply() would have
triggered unless the conntrack had already been deleted from the
lists...

Which modules are you using?

-- 
/Martin
