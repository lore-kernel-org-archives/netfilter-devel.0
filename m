From: "N.Kursu" <kursu@linux.se>
Subject: logging suggestion
Date: Sun, 20 Apr 2003 19:38:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA2DAFF.6010801@linux.se>
Reply-To: kursu@linux.se
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

Hi ppls!

Why not let iptables/netfilter specify where it should put the logging 
output. Now it defaults to syslog, but in the end... the logs get really 
really huge if you log many things with iptables.

So why not add a flag to the userspace app or a givable option in the 
kernel configuration that enables loggin output to another file.

Thanks!

Niklas Kursu
kursu@linux.se
