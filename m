From: Jerry Alexander <jerrya@airmail.net>
Subject: IPTABLES FORWARDING won't work
Date: Thu, 20 Oct 2005 16:09:52 -0500
Message-ID: <435807A0.5090008@airmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Dear NF:

         Sent the earlier message and so far no help
         Some additional info.   It is a linux 2.4.20-8.
         iptables-save  shows ":FORWARD ACCEPT [0:0]"
   which means no packets/bytes have been forwarded.
         No error messages from /var/log/messages.
         Other than loading the modules,  echo'ing a 1 into ip_forward,
and putting in a FORWARD rule I don't think there is anything else to do.
          I did  go into System Settings and set it to "no firewall".
          Any help?!

                                                                     Jerry

example entries:

-A FORWARD -d  192.168.0.17 -p udp -m udp --dport 32779 -j ACCEPT

....

           
Dear NF:

          Had FORWARD"ing working a couple of weeks ago.
          Other than loading the modules,  echo'ing "1" to ip_forward
and entering a "iptables -A FORWARD ...."   it worked fine.
          Ran "ping" and  "iperf" and captured the packets on ethereal and
could see the additional packets.
          Have tried  with a kernel with everything built in and a kernel
where I loaded the modules.
           It worked with no hassles when I tried it before and now
for the life of me, can't figure out why it just doesn't work.
          What is strange is that  setting "-t nat -A PREROUTING" and
changing the destination address works fine!
           Not sure what else to try since it doesn't take much to get
it working(when it works!).
          Appreciate the help.

                                                    thanks,
                                                           Jerry
