From: "Wei Koong CHAI" <eem1wc@eim.surrey.ac.uk>
Subject: [libipq] Accessing packet payload
Date: Wed, 3 Jul 2002 11:18:13 +0100 (BST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1231.131.227.136.38.1025691493.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi...

   I am currently developing a userspace program using libipq to emulate a 
satellite link which would require me to inject extra delay and error on 
packets going through a bridge (with netfilter support). No problem on 
intercepting the packets going through the bridge.

   Also, no problem on incurring extra delay on the packets.

   But, while i am implementing the extra satellite error, i suddenly found 
myself confuse over several points. What i need to do is to randomly decide 
an error in the packet and actually corrupt that bit in the packet.

My questions:

[1] In the struct ipq_packet_msg, the data_len field is referring to what? 
Is it referring to the length of the whole IP packet (header + payload) or 
just the header or the payload alone? And, is the payload[0] referring to 
the first byte of the IP packet?

[2] I have already managed to randomly decide a bit to corrupt within a 
packet (which is just inverting the bit) but i'm unsure on how to actually 
access the packet (header + payload) and invert the bit.

[3] I have read somewhere that the kernel would silently / automatically 
drop the packet if i change the packet without updating the checksum. What 
i need to know is that, which kernel will drop the packet? My bridge or the 
receiving workstation? I don't want my libipq program to drop it as i need 
it to be as transparent as possible.

Please enlighten me on the above issues. Really, suddenly, suffering a 
brain crash. Luckily, Linux doesn't crash so easily!

Thank you in advance.




Wei Koong CHAI
CCSR,
University of Surrey,
United Kingdom.
