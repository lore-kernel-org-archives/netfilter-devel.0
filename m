From: avinash m <kukzme@yahoo.com>
Subject: ipsec implementation using netfilter
Date: Fri, 18 Mar 2005 22:56:21 -0800 (PST)
Message-ID: <20050319065622.45027.qmail@web31402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
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

Hi 

  I am a newbie trying to implement ipsec in transport
mode. i am new to writing networking code too.

The crypto algorithms are actually implemented on a
crypto accelerator card which can be programmed using
some registers to setup an encryption/decryption
sessions. The security associations are also stored in
the crypto card.  

I have seen the openswan.org but that didnt get me
anywhere. I am also not clear hoe i could place this
customization into the existing ipsec stack(if i could
understand that)

 Now i am of the idea of implementing this using the
netfilter module. I am planning to place hook on the
loca input and local output hooks. The packets are
then sent to the card for enc/dec.

I this the right way to implement? if not could i get
some pointers to do this the right way.

Thanx in advance.
shawn


		
__________________________________ 
Do you Yahoo!? 
Yahoo! Small Business - Try our new resources site!
http://smallbusiness.yahoo.com/resources/ 
