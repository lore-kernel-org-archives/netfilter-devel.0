From: lepton <lepton@sina.com>
Subject: why not  __MOD_DEC_USE_COUNT when we register match failer?
Date: Tue, 13 Jan 2004 12:12:48 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040113041248.GA24062@lepton.goldenhope.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

in ipt_state.c (and ipt_helper.c)

There is such code in init funciton
-------------------------------------------
/* NULL if ip_conntrack not a module */
if (ip_conntrack_module)
__MOD_INC_USE_COUNT(ip_conntrack_module);
return
	ipt_register_match(&state_match);
-------------------------------------------	

I think if ipt_register_match failed for some reason, the use count of
ip_conntrack_module will increase. Is it not a bug?

I thinks perhaps we should use such code:

------------------------------------------------
int ret;
/* NULL if ip_conntrack not a module */
if (ip_conntrack_module)
	__MOD_INC_USE_COUNT(ip_conntrack_module);
ret=ipt_register_match(&state_match);
if(ret)
	__MOD_DEC_USE_COUNT(ip_conntrack_module);
return ret;
------------------------------------------------
