From: Gopal Chandavarapu <Gopal.Chandavarapu@rtc.bosch.com>
Subject: MAC Filtering
Date: Wed, 14 Jan 2004 15:52:10 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4005D62A.3080609@rtc.bosch.com>
Reply-To: Gopal.Chandavarapu@rtc.bosch.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

A specific hardware and its cross compiler need 2.4.14 version of the 
linux kernel. I have to do MAC filtering for these devices, so I found that

http://ebtables.sourceforge.net/documentation.html#whatdo

  does MAC filtering. -----------   Good till now.



Problem : The problem is ebtables works only with linux kernel 2.4.22/23 
and version 2.6.x

Question 1: Is there any other module like ebtables which does MAC 
filtering and works with 2.4.14 kernel.


Question 2: The MAC filter module should be capable of filtering the 
packets at run time.
That means that the filter should be able to ACCEPT all packets from MAC 
address A for some time and upon users request at run time, it should be 
able to take a new MAC address B and ACCEPT only from B and DROP/ACCEPT 
packets from A.

Please let me know.

Thanks
Gopal.
