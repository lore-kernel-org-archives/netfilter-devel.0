From: Fallucchi Antonio <fallucch@cisbic.com>
Subject: create c programm for insert rules in netfilters
Date: Tue, 22 Jun 2004 11:45:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D7FFA4.3070002@cisbic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,

I must create a c programm for inserting rules in iptables..

I have used  "do_command" function:

char *tablename = "filter";
iptc_handle_t h = NULL;
char *vettarg[] = {"iptable", "-t", "nat", "-A", "OUTPUT", "-d", "!", 
"127.0.0.1", "-p", "tcp", "--tcp-flags", "syn", "syn", "-j", "QUEUE"};
int numarg=15;
do_command(numarg, vettarg, &tablename, &h);


but, the program crashes with segmentation fault doing;

for (protocol = argv[optind-1]; *protocol; protocol++)
                *protocol = tolower(*protocol);

please help me!
Antonio
