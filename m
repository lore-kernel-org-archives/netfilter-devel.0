From: Mikkel Christiansen <mixxel@cs.auc.dk>
Subject: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 11:42:08 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D007FF0.2080304@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi 

I'm still not sure I quite understand what actions an 
ACK packet from an unregistered connection causes when 
running in connection-pickup mode. Mainly, I'm interested
in knowing whether it causes a new connection to be 
registered in the connnection table or not?
 
Thanks for all the feedback - atleast to us - this is 
a quite interesting discussion.

-Mikkel
