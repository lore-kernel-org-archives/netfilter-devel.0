From: "Jim Fleming" <JimFleming@ameritech.net>
Subject: "...packets with TOS 0x0  also packets with TOS 0x10..."
Date: Wed, 5 Mar 2003 13:35:26 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <069401c2e34e$64aae1f0$8500a8c0@repligate>
References: <001901c2e340$848891b0$8268493e@coldunacs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Nedko Nedev" <nedco@unacs.bg>,
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----- Original Message ----- 
From: "Nedko Nedev" <nedco@unacs.bg>
> 
> in log we can see packets with TOS 0x0  also packets with TOS 0x10
> 

The TOS field is divided into two 4-bit fields. 0x0* and 0x*0 are legacy values.
The other values help to expand the address spaces by adding 15 more flows or layers.
The Identification Field is also used to add 14 more bits of addressing, in two 7-bit fields.
The 7 plus 4 is 11 and when added to the 32-bits of addressing provide a 43 bit address space.
The extra AM/FM bit is common to all of the address spaces.

http://IPv8.no-ip.com
http://www.go-mono.com/
http://www.knoppix.com
http://www.netfilter.org
http://www.digium.com
http://www.asterisk.org
http://www.openss7.org
http://www.zapatatelephony.org
http://www.new.net
http://IPv8.dyn.ee

Jim Fleming
Inter.C@T.Inter.NAT Consultant
http://www.Unir.NET
http://www.Unir.com
http://www.Uni%ae.com
http://www.UniR.com
