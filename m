From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: Protocol Internal State
Date: Sat, 07 Jun 2003 02:23:36 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <SEA2-F33vaKHY5UNLWh00006b16@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

Hi all,

In the ftp helper module, why is it that we need to keep the internal state 
of the ftp protocol by defining the structures in the header? Since we 
already have the ct and expect structure, would it already be sufficient to 
identify future incoming related streams? Fill me with the details.

    Ricky

_________________________________________________________________
Send a fun phone greeting to your friend! 
http://www.msn.com.sg/mobile/fungreetings/
