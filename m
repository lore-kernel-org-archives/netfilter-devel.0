From: "VeNoMouS" <venom@gen-x.co.nz>
Subject: libiptc entry_match
Date: Tue, 8 Mar 2005 11:41:14 +1300
Message-ID: <029601c52366$c5734770$5746370a@nsp.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
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

Is there any other way of getting the CORRECT data from match structures 
apart from match->print(...)

ie
char * list_label(const struct ipt_entry_match *m,const struct ipt_ip *ip)
{
struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
struct ipt_label_info *info=(struct ipt_label_info *)m->data;
match->print(ip, m, 1)
}

i only require the m->data data but if i do a rule like

iptables -I INPUT -m label --label "smtp" -p tcp --dport 25

i can read label fine, if i do

iptables -I INPUT -p tcp --dport 25 -m label --label "smtp"

label becomes blank unless i call match->print(...), which i dont want 
because the data i want is not intended for stdout... any ideas??
