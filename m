From: luoqiang <luoqiang@ict.ac.cn>
Subject: about "struct ct_foo_info" in hacking howto
Date: Fri, 28 Jun 2002 12:01:33 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <02062812013300.10824@luoqiang>
Reply-To: luoqiang@ict.ac.cn
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,all

In hacking howto "4.4.5.3 Example skeleton of a conntrack helper module":

              ......
              if (there_will_be_new_packets_related_to_this_connection)
               {
                       t = new_tuple_specifying_related_packets;
                       ip_conntrack_expect_related(ct, &t);
 
                       /* save information important for NAT in
                               ct->help.ct_foo_info;   */
                               ~~~~~~~~~~~~~~~~~~~~here!!
               }
              ......

but in ip_conntrack.help,there is no member ct_foo_info in union help. how 
can I do? Fill in ct->nat.info?

thanks 
luoqiang
