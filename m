From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: blocking/allowing particular protocol
Date: Wed, 17 Mar 2004 13:46:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403171335400.9283-100000@filer.marasystems.com>
References: <0C674B14EAEBD61196D900B0D03DB49F01C1EA7A@blrw502w.blr.infineon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Kumar Shobhit (IFIN DC COM)" <Shobhit.Kumar@infineon.com>
In-Reply-To: <0C674B14EAEBD61196D900B0D03DB49F01C1EA7A@blrw502w.blr.infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, Kumar Shobhit (IFIN DC COM) wrote:

> Ok. Just to veryfy whether I understand everything correctly. First I
> have to register a NAT helper and then in the helper's callback function
> I call Ip_nat_setup_info. Correct?

Depends on the protocol the helper is tracking, but if there is related 
connections then you need to set up matching NAT entries for these when 
the expected related connection is seen by the firewall.

> But now I have one more doubt There is another expect callback function
> in the Ip_nat_helper structure. What is the purpose of this?

Which function?

NAT helpers only have two functions

a) A "help" function which is called on each payload packet in the master
connection. This is responsible for parsing the protocol control messages, 
rewrite content where needed.

b) A "expected" function which is called on the initial packet of an 
expected connection registered by the "help" function, responsible for 
setting up the required NAT mappings of the expected related 
data connection.

In addition to the NAT helper you generally need a conntrack helper. This
helper is responsible for tracking the master control channel and register
the expected related data connections. 

> I reffered to the FTP ALG (FYI I am implementing a SIP ALG) and I found that
> ip_set_nat_info is being called from there. 

Yes, and also from any other NAT helper where there is related data 
connections involved.

> When and how will this function be called?

On the first (SYN) packet of a expected related data connection. This 
confims the NAT mapping of the related connection according to the 
instructions of the master control connection.

Regards
Henrik
