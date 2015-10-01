From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: rename nfnetlink_queue_core.c
 to nfnetlink_queue.c
Date: Thu, 1 Oct 2015 20:07:45 +0800
Message-ID: <201510012017.vqRsWNtm%fengguang.wu@intel.com>
References: <1443700959-32673-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
Cc: kbuild-all@01.org, netfilter-devel@vger.kernel.org,
	chamas@h4.dion.ne.jp, chamaken@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7857 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbbJAMIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 08:08:34 -0400
Content-Disposition: inline
In-Reply-To: <1443700959-32673-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

[auto build test results on next-20151001 -- if it's inappropriate base, please ignore]

config: m68k-sun3_defconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 31ae4524f70d7992a3f918bab674e2fe8588edfa
        # save the attached .config to linux build tree
        make.cross ARCH=m68k 

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings

All warnings (new ones prefixed by >>):

   net/netfilter/nfnetlink_queue.c: In function '__nfqnl_enqueue_packet':
>> net/netfilter/nfnetlink_queue.c:518:18: warning: 'nfq_ct' may be used uninitialized in this function [-Wmaybe-uninitialized]
     if (ct && nfq_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
                     ^
   net/netfilter/nfnetlink_queue.c:316:22: note: 'nfq_ct' was declared here
     struct nfq_ct_hook *nfq_ct;
                         ^

vim +/nfq_ct +518 net/netfilter/nfnetlink_queue.c

7af4cc3f net/netfilter/nfnetlink_queue.c      Harald Welte      2005-08-09  502  		struct nfqnl_msg_packet_timestamp ts;
b7aa0bf7 net/netfilter/nfnetlink_queue.c      Eric Dumazet      2007-04-19  503  		struct timeval tv = ktime_to_timeval(entskb->tstamp);
b7aa0bf7 net/netfilter/nfnetlink_queue.c      Eric Dumazet      2007-04-19  504  		ts.sec = cpu_to_be64(tv.tv_sec);
b7aa0bf7 net/netfilter/nfnetlink_queue.c      Eric Dumazet      2007-04-19  505  		ts.usec = cpu_to_be64(tv.tv_usec);
7af4cc3f net/netfilter/nfnetlink_queue.c      Harald Welte      2005-08-09  506  
a447189e net/netfilter/nfnetlink_queue.c      David S. Miller   2012-03-29  507  		if (nla_put(skb, NFQA_TIMESTAMP, sizeof(ts), &ts))
a447189e net/netfilter/nfnetlink_queue.c      David S. Miller   2012-03-29  508  			goto nla_put_failure;
7af4cc3f net/netfilter/nfnetlink_queue.c      Harald Welte      2005-08-09  509  	}
7af4cc3f net/netfilter/nfnetlink_queue.c      Harald Welte      2005-08-09  510  
08c0cad6 net/netfilter/nfnetlink_queue_core.c Valentina Giusti  2013-12-20  511  	if ((queue->flags & NFQA_CFG_F_UID_GID) && entskb->sk &&
08c0cad6 net/netfilter/nfnetlink_queue_core.c Valentina Giusti  2013-12-20  512  	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
08c0cad6 net/netfilter/nfnetlink_queue_core.c Valentina Giusti  2013-12-20  513  		goto nla_put_failure;
08c0cad6 net/netfilter/nfnetlink_queue_core.c Valentina Giusti  2013-12-20  514  
ef493bd9 net/netfilter/nfnetlink_queue_core.c Roman Kubiak      2015-06-12  515  	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
ef493bd9 net/netfilter/nfnetlink_queue_core.c Roman Kubiak      2015-06-12  516  		goto nla_put_failure;
ef493bd9 net/netfilter/nfnetlink_queue_core.c Roman Kubiak      2015-06-12  517  
d343eb79 net/netfilter/nfnetlink_queue_core.c Pablo Neira Ayuso 2015-10-01 @518  	if (ct && nfq_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
ae08ce00 net/netfilter/nfnetlink_queue_core.c Eric Dumazet      2013-03-17  519  		goto nla_put_failure;
ae08ce00 net/netfilter/nfnetlink_queue_core.c Eric Dumazet      2013-03-17  520  
7f87712c net/netfilter/nfnetlink_queue_core.c Florian Westphal  2013-06-04  521  	if (cap_len > data_len &&
7f87712c net/netfilter/nfnetlink_queue_core.c Florian Westphal  2013-06-04  522  	    nla_put_be32(skb, NFQA_CAP_LEN, htonl(cap_len)))
ae08ce00 net/netfilter/nfnetlink_queue_core.c Eric Dumazet      2013-03-17  523  		goto nla_put_failure;
ae08ce00 net/netfilter/nfnetlink_queue_core.c Eric Dumazet      2013-03-17  524  
496e4ae7 net/netfilter/nfnetlink_queue_core.c Florian Westphal  2013-06-29  525  	if (nfqnl_put_packet_info(skb, entskb, csum_verify))
7237190d net/netfilter/nfnetlink_queue_core.c Florian Westphal  2013-04-19  526  		goto nla_put_failure;

:::::: The code at line 518 was first introduced by commit
:::::: d343eb794f25c72b22631ffc19be0d15fc7f607c netfilter: nfnetlink_queue: get rid of nfnetlink_queue_ct.c

:::::: TO: Pablo Neira Ayuso <pablo@netfilter.org>
:::::: CC: 0day robot <fengguang.wu@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--WIyZ46R2i8wDzkSu
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICEIhDVYAAy5jb25maWcAlDzbctu4ku/zFarMPpxTdTJx7ESV2S0/gCAo4YgkGAKUZb+w
HEeZqMaXrCTP5e+3G7wBZEM6+5JY3Y1734Hmzz/9PGOvx5en++Pu4f7x8e/Zb9vn7f7+uP06
+7Z73P7PLFazXJmZiKX5BYjT3fPrX++e5p9+n3345eqXi7f7h6vZart/3j7O+Mvzt91vr9B6
9/L8088/cZUnclFn80+r67+7X+WNFlm9ELkoJa91IfNUcQffYZY3Qi6WZorgLJVRyYyoY5Gy
24HAyEzUqbqpS6EHaK5qqQpVmjpjhQeOMzb8vlO58CHLu+v3Fxfdr2JhWJRC/2ItUn192cFj
kbR/pVKb6zfvHndf3j29fH193B7e/VeVM5hTKVLBtHj3y4PdoDddW1l+rm9UiYuH3fp5trBb
/zg7bI+vP4b9i0q1Enmt8lpnzgpkLk0t8nXNShw8k+b6qp8WL5XWNVdZIVNx/eYN9N5hGlht
hDaz3WH2/HLEAbuGcBgsXYtSS5Vfv3l7eH2+ekPhalYZNUwGtoFVqamXShtc8/Wbfzy/PG//
2bfVN+7u61u9lgWfAPB/btIBXigtN3X2uRKVoKFDk36JqziqNLG2ZlMykanytmbGML4c+kyW
LI9TZ5BKC2A0t19WgRC4/dpTg1OcHV6/HP4+HLdPw6l17IqHrJfqZuiYlXyJvWugMci0Kkm0
MB0X8KJ6Z+4Pv8+Ou6ft7P756+xwvD8eZvcPDy+vz8fd82/DIEbyVQ0Nasa5qnIj88UwTqTj
uigVF7BowJswpl5fues0TK+0YUZP1lryaqana4Vxb2vAuZ3Az1psClFSXKZHxHZEbOLSel3B
fNIUmTdTOUlkSiEspSkZF8F+cEpwiqKOlDIkVVTJNK4jmV9yEi9XzR+k8GDzBM5bJub6/dyR
ukWpqkKTHfKl4KtCydyg5jKqFETXKFS6gJVpd98qo+uc7hWlKYAC3itDuELGIVQuTAilYQ2x
VQl2nTTNrU40KIqiFBy0d0wfEap0YvlRuoKma6v0ythXgiXLoGOtqpJbVdd1FdeLO+koHQBE
ALj0IOmdq/MBsLkb4dXo9wf3ADivVQEyLO9Enaiy1vAHxe8jtcZy0KAyV7FrqZZsLepKxu/n
jqQWiTtcUKBGzTLQxRKP2dGwoGwyEDM7F5AlT/fi/vVg98Rg1h2GGHUFYH2bOWsoSmBjx5pH
laOQRJqABJeOjo3ALNZJ5c4mqYzYjDbFwmqeFRu+dPsrlLcOuchZmjjcgcq1dAFgvHNjAYO4
F8mJFeolmAvn3KTDDSxeSy26xs4m4MZbc+gODf1ErCylPZPhQLNIxLEvDFbTti5Vsd1/e9k/
3T8/bGfij+0z2AEGFoGjJdjuD4MKXmfN4mprB8BGDyOjxWcG3AjnXHTKPNOm0yoKSa0Bfy1m
htVg+mUiQXhlQAeDTUlkCkaI4hWxEbw7/kEVQZNI0ErFHv38QwRuDrh8ixw1DEebRfRubeoN
g/Wj3itYCQfTeTG+uIIhAW1bKiM4qFqiKztspuKmT10Ijot2DlLFVQrGG07ZcjSqrJPYAanA
sACX6gp6zeOrCYJx00y4cQe5Wr/9cn8AV/z3hht+7F/AKW88gMErwWkuGXgTQN8egahH7Oxv
auebgL8LJ7IUJTAOxfzAJDJPXAUIXjTKoqu2rAzrDHXHxWgX3K1vQKgkOXrpLCYGbGmqHPHB
xg2aXB3QtadOs1TbD7gfvRsb2KeO0rfzYzSKVklzZOSHNWkUs8TZtNaeRXpBAhvPc2L8jFiU
0tx6+guQPItB6kTD9+VElxT3++MOY7KZ+fvH1lEaQG+ksdsQr1nOhbfpDIQ1H2jIfWDgh5+m
UDqhKboeMuD7gcJRr4aVkkJkjJNgHStNIdDbjaVeATe7wpiB77CpdRURTbRKYXBdbz7NqR4r
aHnDSuF12684jbMze6IX8gwFGI8ytLVdJ1XuzW0If1iZsTP9iyQwAycem3+i+3e4bdq+CYnU
TD9832IQ7NooqRo/MVfKjWNbaCyY7ff6aYzhyedppNkA+0l1YOybWE+Hbru8fvPw7X97T5Hp
/L0zam5Xh5kJq2ogwoIYznU5Lb6E6bb4Uziy7U2JEUigsYtsW/erTCDIuROU1cqyymHtrEL2
cAyMtb6OSEDwg5rdRoGdvSke74/obPT5hwa6f3nYHg4ve6s8/KwOT5nW1jY66YU0TiQZwkCL
i8uLfrS+X/1j+7D7tnuYqR+opA6uccNREohvRUaHhp3eolgY/BBQ0W24z5dVvvK0G5pNkF/4
aeQCqGqRY4aHyhvABNDAsjhGZV/3cVh3KkXVrSq7f/i+e972inYYDtUcvQTUc7SRYXQEytDv
VSRqndGh77K4urigdRHwyYbEfP5wQaudq2610ethpl9//HjZH9219qkPzdDFCPm2yfb++Lp3
7VGSMuP52wioMUzCYxwl8ARoBhvnFHDKXSjl+znI5tjQsjqSUOspUnAwC2PFDU5aX3/wk2WN
U0b7u8vbhitq0ziqRP9dYhHXsrh+P0hgBXw7LGctwbcyCgImbxkrnZ3QZhnsCNoxO4frDxe/
zr3dgVjR8u7K2VGeChAYBkrQ1ysgBZiioxZQKJWCeuyJ76KK9r7urBeoAmmTOEWTsRA2QbMa
BQmWL8Rf24fX4/2Xx63NPc9s5HN0+AO90cygX+2rHLTEVVb0+4KO9xJ0MPh4lGfW9KJ5KQsn
KWY5hqnKzZM1lBb4NAJmoDoGIM4Bp+Dyp/F+ABMuUHt0spNvj3++7H8HZ3720uu93i/jK7d5
8xu0FXBQPyQ6Ib5LMiLYJKVz8PgLvN2FcrfOAquRz+hjwUGqQd9ITqVlLAVoNkzHT/rFFKLU
RnLqECwFxGogYMOMcZtWwnNvW1A3CNGTbHbaSXw1aoEzTSf4gKAzG3UJR0vaUyCyuLqxcW7K
qaiLvBj/ruMlnwJRAU2hJSuLEW8UcrQNslggV4Pd24wRtanyXKQE/QDStznwpFpJ7yrE0q2N
9JtWMd1loqoJYBje6RdPoGZL14UCgNDFCDI+bgu0jDAe3mJIYMNxaBFAjeQaL3bCFKc7iIQw
rl6z6LRUAR4bSVczRV5QYNzRFjzkp4EU/jzpsvQ0vIrclEOn1zo8uK+vX3YPb/zes/ijJtPS
cOZzZ4bwq+V7cP9E4stOh7M2MyA+QNMkPVG465gM5XEf5hOmmE+5Yj6whT9EJot5YDG1TNm4
lyAfzQPQs5w0P8NK8zO85OLtnraZ4kn+zF2ZJ50WoqWZ7A3A6nlJ7juic/RrrcNjbgvh6p81
sRsIbJTH6AA658refIZuGZDQri50Z4A3nLUWPGPlirrYEOh9Fa2eTcbK37YGP8vmcsGiZAWd
XgTSRKbGz672QJCgqDrZzM2AdIa+lDG4K0PPT+0F3ct+i+YbfJTjdh+69R56Hgz/BAV/Qcy3
8tSsj2pu7k7gm6vREwSpctRTjhn4PLcumAfFq6vmdo0mrvH4nCW4KHRxPa/Vw2KImQRulFw6
m77+D+jsjWlFm/YJoeUY6txdQpvBmSzA4MzBI485D/XQkXim10VobgoaAyYC4g4R2GyWsTxm
AWQy7rPHLK8urwIoWfIAJioVi9FZCuCBjyKp8J4xQKDzLDShogjOVbM8tHotQ41Ms/bRObWc
HuSInuI079CiBc3p08+Zv2M5hqoQdrkqpAWHj3zATlgFUQQfIHjMAQgbHzDCxhuJMEM1huBF
loJWNOBKwgw3t16jxiQQoMYdJ+AAjsXaxYCLuDHLuPRhmTDMh3jTgt9lhHf9PmzJ9HLUqrkH
84EjXWjadzP+BJj+PBoQd8cHjQ7fTNSwbfZvMZm7hU02ybSXdNT+b/q9ttZnYwPkw+zh5enL
7nn7ddY+NqIsz8Y0apvs1YrVCbS2U/TGPN7vf9seQ0MZVi7AmNvnDLrKAt12VJ25P011eood
VWDfOnyseXGaYpmewZ+fBOY37H3zaTKfAwmCEyPlIQbp2uZ4xX9mqXlydgp5EnQqHCI1diII
IgzZhT4z61PKZ6Ay4syEzFhLUTT4NugMCS8yrc/SgC+vTWn1qyciT/fHh+8npNHwpc3WWcec
HqQhwpcfp/A8rbQJcltLAw4dOFVnaPI8ujUitOSBqrnoOks10qg01QkuH4g6BiNM9EBXVCfd
+p4Q3biTI4J1so+XThOFVUlDIHh+Gq9Pt0dDdn4LlyItzpx9UKU1aCL1NiWBuHhxmkvTS3O6
k1TkC7M8TXJ2uRnjZ/BnuKkJZb0In6DKk1Cw1ZMofVoq1U1+5lyaXOppkuWt9n0lgmZlzqqQ
z5XyfKkpxWn93NIIloaMeUfBz2mZkXdLECib8j5JYpg5veA+43yGqsR3sqdIThqBlgRs/UmC
6urSTbK0/pT3Gyg315cf5yNoJNGM167zPsZ4EuEjR4msBodqheqwhfsC5ONO9Ye4cK+IzYlV
WzS1AouAFicbnkKcwoXXAUiZeI5Bi8Un/e25ubcH6+nDaFn893+QEkowk1symzb7EArUx6gu
rhrB0dFmMu+ytRNsF2lMEHFVBAfBiwkXTNJiqmhMiLAJYWAKTbgaWA6Fs0AMyypRsphaLCLJ
PQDPku4Okxb4dE1Oo2Y6p2Mx43QGAv2kC7AHwGUxDpAbeOv/LWm45zu4iLLoM5AE1ph0jKDJ
e3/bj0s95DTab9Be7OG1GA4mQDCOSkaTGTv/3dLw9UagUev7ylCnxEZ2nvt0r0p2MwYBd9Pn
x0InAYhhyq1G+GP+/9UJc4+5PJ3gowadMKeEqNcJ87E8dAI5QrRy7g9CAgNddApgPhGP0Bwp
HCHoo7adoE8W1gq6d881D4niPCSLDkJUcv4hgMPzCqAwLgyglmkAgfNunisECLLQJCl2dNFm
giASHi0m0FNQabhYSmvMaTGeEzI3JzSM2z2tYlyKvCCTjs0Vjs8r7bXONM/YIqZpu6auZ9RV
dzuU1CIac1iLAwRm1yszbYYoM9lyD+nth4P5dHFZX5EYlinXr3Uxrrl24DIEnpPwUaTmYHwH
0kFM4hQHpw09/DpleWgZpSjSWxIZhzYM51bTqKn1cacX6tBLoDnwUWoNLIOfdGheEfDhzYA1
FPZ+iXMZHyY2wnU6bTsku5xeZpJ0V/SrljYSc0q3DDSKFrWK/s3pMgBL0T27tY9KMCHK8cGB
V0MSotNL9j5QNhZokaucfKuH9NMZhLA4rlu85Ugo/MAgz90IBIV3FsKcwGNMQ73Qa/Miw5tw
+F2vqSMhhGDCXHIBzqrGp81egad9sWZ5SjP3IFB+UE28/0zOOAb3SJC1vyn35pzyywCXbYjW
zLDUy9ZhyQIrilQggn5gdvmRhKesoKuRiqWipz5P1U3hao0WUOdLTgJhdm7ew8WgdffTpi52
qQoa4XsfLiZTkUyxbIPEooHw8hEusor9hzFCCDzYjx+CFZr2fTt97jwidi7ONZadKizsdot6
wGe3ZSEOM/awOnJLnhx4zAwJzzkJzuy1s8O5qhD5Wt9IcF7o581NmihYn2qvbfFVLJ0Ttmj/
vVZWpKMXcgipF1r5NNNjslDwLrvnNMPTY00/p7SnY9cGkhGkSK/Q3WnerKzpZdTlBt8J39Z+
/WP0OR09Lp0dt4fjqFzMvrdZmYWgnzQvWQZ+lqSffnFGN5JlTL9tj+irdgYe4KYMKNQbid9L
0PQZ38iM0a/Vy2QlA7VcuORf6aJkzmRCI0SBmWlaDeUJp9TnTcsL7SHE2z92D9tZvN/90ZTB
DB952D20YKrmoWoKOZscP/n6e22yItHu+8AGApqmyh0J1AafD6SgM90K3ab7RJaZrWGy9e7O
k/sbW53nP6TqiSFwW4kSFknMS2wgWu1JvY9O9J02tefN0uqEpWkE8S1lTFL8kAdaEOdltVuU
Wi/BqyzXUpM1nP23QooKO5Gjsnl8jg/OAXSM5foJUTKHlQ1f7fk5V3nwX26rRl1pzwytbRXN
VwX4sIos4W6r/Ma1fbgHeZWm+IOWsZaIw4ZNv48wIkq90isXausI7KOJ609jPC9vC6Ns26cx
Li6j2LP68Ltui61yjKTox4790mzrEbBk2XSSAGzn935O4bD03quB4HGpMtR1PF47g3jg9vw1
rHkQfY/gxhZL0P5OrcBo1sLeb03OY0nzRT/laFr0ne0ODw7bDfwucuBzjfnoq3R9cUk9/AQZ
yW5tvZgzF5HzVOkKBFejsPDAK04N+0drwcsxszaFGgKi/Wx2mJb+NJj61yu+mU+ame1f94eZ
fD4c969Ptpb98P1+v/06O+7vnw/Y1ewRi6e+wjbsfuCfndJkmEK7nyXFgs2+7fZPf0Kz2deX
P58fX+67FzAdrXw+bh9nmeRWiBs12+E0B3U/BQ9Nli+HYxDJ7/dfqQ570LANfBmwoJvUFkwH
kY12Bb+ZLglDEiGWxPnbYEDGXhmG9Cue2hlr2fKYc4B9CKUlPlh2oiYmY/xWTukET0jlB37Q
alTo5SNPvdBrxvzcxYFk2AcU+Iy0TvryGbuMdv6z498/trN/ANv8/q/Z8f7H9l8zHr8FPvyn
UzrUip121saXZQNzXP0OprQL7VuXU72kyxoMaqxKomOvAqCHcur87CLhb7TZRk+2N1WLxejl
s0+gOTrV+jbn9JGbTsYOo+PWhWwPeDxmwhtEaLbS/kswR62xWrKFj6bJUI1F8N+JpZTF6YHB
N7Df4XJetlu48bItFoQVOM0XTiZTCb0JxwrHAI/TUYnFKR3br9FIRn9WIounrJM5ZimLayz/
ZaUHQvG7mEDeTyFTog8f556f0lVLMkOvImvN9m0I29660FYtZCV7NyGzjiaEUNNtiDPPgcgC
2sClCJ2dHSaRTvCGEImFzuAq5h64wE9AwIrAGcbPm3g46/F4EJ2zQi+VDzRLcJpAM4EfCm5O
Ex660wztCqBE6Y+YybL0PUsAYuIZPWZbcUz3g0ftdXQnSn/5/bGPd7mD15/puMmjCRTT2bOg
v9kEqCaU8V1vLIRdCZrLAIsfmQnwIJ7CJDfgb5Ytnne0Uf+O1L3NNTyrZfN9Dg+GH05xWQdh
hVUEblYMvODIvkW3XdPxcKONJgRDPDoEJU6MOv44TqTymK52sc7eMFHxuWIpuL/+y6PaCJZN
IW3BEvHq3yMowdUGRziSeZACgksVHADLptcCd2r0pM6hwZgwYinW3Tjqi3H/AgABxr9A9gnW
G+8nBn9r/20O2lWVkrA6vs1Z5lbb2bcibmLFpkyU/fxcbkr4ww+OIeqnU8ZVXq/tudrvDpKf
FliPgoc8zYjvadgsxeAkf/UzCvEOHOrdl1f8Zqf+c3d8+D5j+4fvu+P2AevrHXIvIxJrVmfr
T5/EfLOhUyoTqropKyefXMJC0HUdFT03nlHNXOuH9rU581Gdb0dc0okhu5UshpiGdp/jPCCO
Tt/iji9lIDvY0eBndlJyGfLT5cfNxl9JDbBP88BSMlaCmxLOSnVkkpfiLFXOjBYZHRc4ZKgL
MA9wjq4EMQm5YS4ZZlzDCc2WSrMMNoN2T10yIeg7CZfG4HbQ4ZNLFpA6l+Q2VwX4fufo1pIO
XRySG3kX4q5ieTvKE3aIwtFZ8AM/ROQ/ukUgODqp964RgX0powPLisKr0bQwNM/jyGrAK69b
44+s/Le72J0NH3wQQmrj3l3o1L011ql7wYK4/qNYbiGURWgQBzOCWTuAf827yA5D8LeH3dft
rNJRH+Lh+rbb/2vsSZrbyHm9v1+hmtN8VS8z1mJZPuTAXiTR6i29aPGlS2MrsSqx5ZLkepN/
/wCyu8UFlL+qySQCwLVJEABB4BnDEh+OAtPauNnz9h0dbAhrxCpiNjMN30SEidUeLcl/2mEY
/tM7H4B61zu/tFQEB125TOFFQMRDenv/ODuVbp5klR7BAAH1dIpBT5yWcEmEx5LrNkFSFCIo
2MK4EzGIYobhpkwi0ffqtDv+wii0e4w4+H2rWUSb0inIqNJ0ScJBiGLV2oktgPmFSb3+2r8Z
jK7TbL7ejSdm5x/SDX1VItHhUvpSG6XCpaFBKF/KstxrJUF49VKWa7HSWhjorQuPNvx1JNHi
U5IkXJWOmDMdDd6VocRIL4+OrCjTFVuRAvqFpkqgS+R41uZ47O+jlhMA+N4DoojEgTbDmXZf
JuHypjitHDd/ksjz49v7O/ryU1IsC5BTGM3Pmw6AvJdhVJIauYh7T8CyQldy2mglSYTfj0MF
kAQ4Hrl2r+0+0BeslTjfHp+FmZP/nfZMuw3MoRKVUfzE/wsXZ9VoIRBwOhkfxCDI2eoKluFR
xMxvahABNnap6001ue+sY8bikDQ0+y/b4/YJubt1GVOWSuj3pXKstHK9iOoQiWALhUrZEih+
FCsbBnQXMMb8CTTXCwy3cz+ps3KjXyyFy6wsLpETuDDnuczuUThj/kZU4pw4FqEzjLzIy2mu
kdSzgpb2xHM3DIRGyQfQVxlrS+39AkC2/XB33G9/Uadg00MQgW+sUsnh7YtAnGRxcYwTh3RT
RwWyAT6PvjYThe8na0d0aUnRLNaHks2wwv+C9FMyhzbCs5jXMmY8LR3D8pEaMn1dPbwf03wM
dmMd5KA709WWPvzJ7I/EBz41u9wRxbxwXDAUmUPDmBfcajPLClucAaAuphJuVe3KLTNB/vtS
3dOvvbwZsoeCNfkRR3vdQry0JYXejiYKZIQuqvws0z0cuuab7BeHo9oDiS0z6Nzh6ScxYhhG
/3YygdqlTUmVMxv1ACWoxBXORBE4t8/PIlQrbBjR2ukvTeqk/eiydIUP9Ss4QmnLmSRgS0eg
5ZUzqD7o9DGjNdMVuhgHqS1DxR+/zvvvH29PIuRsI/USzCOeBsLkRfepxCCvBfeHJBrLLsI4
ixxxgAEdl+Ph/Z0TXcS3N/RsMm99e3Pj7poovcHAkU50yWsWD4e367osfBbQW1AQxg5Xmzyc
VZF5lXApGgaciQ9OnZqz4/b9Zf9kLeHpcfu66/3z8f07HKiBeaBOtYDgnccHtETJf1OvjQOr
lfLqwDFaQIm7mGVYkD1XCX34AypwhK6512j8NNtAH2lpr6HhMZuFXsSvVpSjksLXIXp0JTU+
h3ZRo+vJZ11Dms+6hjSfdm0KS5DPkjoE6cOhb7ZdSh3JJRC/nDGXJxOgY+ajEu4sjibcCFPx
OCtAFV669DgrKXkkRlpScR+1dfnSyr0Ex4CKKlw/zpH2g/7QZc0EPAbZrBzsDAcSlnmapI4Q
qjgVaDQv5qFD5gcKVqX1on9/4+xCwYFp0Q10E11HfnB1i8AHFY9hbXn58HY6/BIeFO+/tr+b
ObRPLOksYgm9GhhD+VYxyM6TGxqfp6vi6+C24wg5SPHSnUap+TJ2Gw1yAUbhx7u5mOX0yUUV
y9PSFUMtSmeKYoS/8Fa1WsMiTWgEzKWaOUPB+FFVDgZauo8CL0VsVQ04pDXFc665RcFP9HwF
kXODD5DFq3ii/0CGb2MuegZRTePcZovpGEcZ5AbszrNpusCCbATTPTerY35eUf7cAodKuVWg
wifhjhJeGC3UKyOE+SBF5BsTxuGXCdwIw6HZIEzJLE1y7nCbQZIwBh5Ie9wJdBT6KeWnL5CP
GHPUmuTY4w6FC/FQxG2sEAQbd29XoHuktB4j2t7k7hwbSMDxGsSJLVc8mTNqd8iOJxgZuxSX
4Vq5yBdiorPeKEzSJRUdUyDTGadWVwuvgwd3xS0N/MjoaelIHB8Z8XkVe1GYsWBwjWp2P7q5
hl8Be4+uLiY4tbkvbEmOuRD3F0U6LfXVDSwItr+91IS14PpigoMgpA1RiM1YgoJ6lF5Zrxm+
wtgk9LkkCGA/wrnjxkcMLz8TI5yvTpM73bMRXTB+bRjX7pAEPgvDwOlGJihK/HbAHF0ZZbiw
dWZR5cbnLv0XNyYa8kApoQUQUTtecTykm6tNlHxJC/0CCZJc6HjBIfDzvCpK+UTgCoPxHXYH
xK55Ers7gP4jV7v/uAngzLjCnqS7aj2vqFuxqvDqdO7zGqVBOMylbKuceIBvZB8d2OW5mfua
qdqw4spLC4BRV+UIz15+nzDXZS/a/kbDoi1mYmugo9PGtjQT+LUfcvraBbEzFrh8Q6oVLYnH
sUNLhKPNaYZOwhWw5YD+VjJZEpdvj4gvkYOKreWZQYCIy6aD5n6ZFhsa2HjXf/3jeH66+UMl
wMRR8J31Ug3QKHVRekvfthXJxIOlT15AYQmelNPGxe+3BW8SXJhgw9FehdcVDzHfBK0miC7m
Syt9ppTAMi56aqy6LrGGjrPqDIr+YDK+2iyQ3PZps4VKcktbTRSS8eS2nrKYOwxGCuXdiDba
X0gGoxuHKbMhKcpF/65kk6tE8WhSfjJ6JBnSTwZVktv76yRFPB58Mijv22hyc50kz259hwWp
JVkObwa2Yfzw9gWjlumLwSjZyPitLRFF+mL3htlSHGuIVeuAF5nhiXfhOg4zk0g7Ia3NdlCb
5f543h+o1rAYT4FnEWbUeP90PJwO38+9+e/33fHLsvfjY3c6k6b/kplOzfrdV/G+fxM2V2NH
+QJYHD6OtGkR04hEINLQLDhmPPJSWk7hqUyeQ1vW8t3r4bx7Px6ezB7l76+nHyawSP3en4VI
ltpL33r+y/79P71Tm+4mIO5TqmTN3c8xoD4QHmgLL/phLqe5w78mXKO/m+uASR3KN3esmmxF
949nIqCwQ3YA1U6G9Gx86Gh9P7YVWzyL1ayzHXH7zMt1WKOhPVuzejBJYrzAoE9YjQpOb3rb
e35cL9KECQp3i6hB+Q5fi9i3JRU1wePr4W1/PpCeLDmztyd7ez4e9s/aukeXTe64JlxSd3vd
2WRdsIoHF3OWB+I1X5ucmLiQlTY8TNgiv5C2omHhgTpGLwjADQ3cBTOq1fNcAPD2HpOsYp3q
6d1QN2mhmU+f3C1VEfqV08VYEIWJcP925k5DGteV1oMXaH3D305ifLHptcl4ul3CMX1oUesv
FjqwCK/r2F8NifhyzvwNSgP1Gp9ZUKOw2n/4dH4fPpvbh+m1AAui+PWMMWafECJiHJIVrj/t
MVI4LKyIgnVPL4D11YHMpoW54hsMxsEfyDEYkDod+B4B7nz/lXCvXUOSSnQEn4wvopTukErn
2IleKRcEzTh4ZA/pwrAH7pI4T4yyLaqfRt3keOiq216kMsVLVc35YlokaSlTRTSQwARwCaj1
HMhTZtLJEJn6zy5SADoC5yIwoLKhRYbjhhBXiOtRlqRw7XyJbeKYX8pgYqklLVNKHOVXJerS
00tXZTotRtpSmwruqQB8dN26LDmQAEF4lBSSgW+bQMbK57Tes0i0eGz3d7AMxDFwOQXaj1Gk
9+PxjcbQH9KIq87ij0Ck4qtgqvUWfydR5yoQpMXfU1b+nZR0k1OMkq8Ul8lBVcjSJMHfl1g0
QYi5yr6OhncUnqf+HN0qy69/7E+HyeT2/ktf0WNBkzT3hDxsT7uP54NIbmb1+PK+UQUs9HzZ
AmYmExdAkVktThNeqg8RBcqf8yjIQ8XGgo9M1aYM5bmNLtCNRwYXuM5MJY11oFwMQ9UMtpUn
OkosYvnXVP9G6BgneIDMQq31KRXBid28hwUWrsVMjWZCcdzTIBCPi0JoKYq/mFEefqPBzDid
LtBPZs67MgrPjbpSCk4CcuQ+KBZqx4tvFSvmFERyXitPoI6WsbOIdjqyAK9dsiYVJ1lRQyFs
4LTOQ1Hi2z0j8rddwCXcdASPmvWrA0ePIxKakgNYP17vxUi8ccSnjhig4DotlQ3emvkmOpH8
ODLqwVDRzNeuZS/zHevbS0JqD5eTsMPW/THmW+dJEK5V//00Ntd8ZgC+JeuRDRpbQlsDdMtP
edMWrV8VZUoml8WExfqBYbUsIfKJIG0kofrVsvTGd0vnRi1StqX9Xg6M30PtjZCAmCxBRWoh
a0E0XrHMqmBU94niObrZJNPCJEcBoHE5DRJqhbRETQyCINGHFGg9CuwRBcSQDPyIaHYmvFQz
9BJWVhxKfeZPnBVtUpuMVeqDrDzzzd/1TI3l3cCaCW3nLPNBd0HCepF7t9pbcUnvXrAiVBDN
b7m+AvG3UHLoxS3Qq5At6mwlIlO7qarMd2WuF3j3OSzQVwYj0P9FC0XsMJQkfuaYjTRgxpZk
LmaVaFG5oqKVvDR5S0G3AlsNAptesMPcAeaVxtzdOjCT2xsnZuDEuGtz9WAydrYz7jsxzh6M
h07MyIlx9no8dmLuHZj7oavMvXNG74eu8dyPXO1M7ozxgBaBq6OeOAr0B872AWVMNSt8zun6
+/oia8EDmnpIgx19v6XBYxp8R4PvHf12dKXv6Evf6Mwi5ZM6J2CVDsPwm3CQq8+yW7AfRnqG
hg4O6nalxi7oMHnKSk7Wtcl5FFG1zVhIw0HlXthgDr1iSUAgkkpLTqKOjexSWeULriUjA0RV
TpUVGUR6wIuIiGfxP0qi9Jft008ZxU9A34/7t/NP4VH+/Lo7qfmjdSuFzHdHiYJCp0HLykzE
Uem466h1I3x9Bx31y3n/uus9veyefp5Ec08SfrQzVocJPoUSBhGoLAO9gJWq/Njg46poEoQp
Rhn08BMl5QNA5XYox1TNRQzCXUyfmFWC7wMR76URTULZvVoZVqYI7zpklClk8DLUQkU4bWoi
0RUIZc/822VACvCSkVyM/+vNv32zFTucnrxF270ejr97we6fjx8/jBCOgl2F6xI9uUgvyMYm
KC52RFCazmyC1fWiw9PPj3f5Sefbtx/6yoF17dcw7NRwKabw9ZJFFQxLRzZZFgF8+ZYYldRt
k5YdxnKLMDQzvIreYZ8vs9H789TcDJ7+t/f6cd79u4N/7M5Pf/31lxL0ScTEknXDn2WYe2mh
urvaGHmX51eOic9TqBDRpBonXtoiGhR+YTukDSVpXmJENtKDIP94E5uutAN3sjKNuT8ewbqM
pmbhlkY818aQMGNR/4Xn4C9Y8GsRSlGHynw4rQe3gVwAtkzXKr8ScMFgpkQXBDZH6VW8jrxU
J+JM1kHqF7kioQvyaBEbzYowkehDb8C1rGgC0sWbNCoQUWmskTLMWL0IN3o0KIY+2Q4DDGZw
Z8aFbPMq7unjuD//tpmhqF81GV8CDQEKJ9vRVlOWuhCTV1JhYHe+uXKpA+Dq4pIVPqfjbcLV
65kWSbLKlo9dWmNEfvIWi7E/G9Q6zWsRakdZWHKV6jF5JAxYlq9+cwldp7kJyr6ZELno4eBJ
lZDFMnBld3l5/P1+PsApdtz1Dsfey+7XuwjbpxHXLJqxjCvvSVXwwIbDIWI2KIA2qRctfJ7N
1TA9JsYuJDKbUkCbNFfDE19gJGF35JsFjLxwKpQYvLPbzDXUvGAWDGQpONJyq5IGbtcurnUc
tdQBL4SwgVu+sIrOpv3BJK4iqzgGWSWBdvNoCZIpMk2M+MteD7EDzqpyHqohNxp4w7vlNf/H
+WUHp8LTFgP8hG9PuIrxZd3/7c8vPXY6HZ72AhVsz1trNft+bNU+I2D+nMF/g5ssjTb94c2t
RVCE37i1szDQJQMBY9l21hOOOa+HZy1ubtOEZw/UL+3v6KsZVLp2PAsW5StinRKNrMvuUmu+
Pb24uqdlJGs3GgVcU40sJWUTkekHnN92C7k/HPjqyaAiSHt9iy77NwGf2otZz3vcToLrG8bB
iIARdBw+K6gFMbfHmccBbCASrBoxLuDB7ZgCDwc2tUjYQACpKgB82x/YO2eW9+9t8CqTxPIc
2L+/aF53Hde22QVLKo/b65Hlvj2VcM6tppz4IC2itVdaKx40IFBjbcaIAdrchYrS/nQItScr
CO0hTI0Yhw14MWePxIlWsKhgxCdr+QbBL0KiljDPtMwKHb+zx16uUnIyG/hlWjqV9bg7nbTk
Wt3ojRBLDVzc/1hc5TG1YJORvaLwloiAzTsmkIN6dXjtJR+v/4DGPJMPy6nusQQjv2bU6R3k
HupxSUVjBHcyV6zEUFKDwCDHpRBWCw8cX6uF6K2nimTKCYxRip2ImmRNHbZwyQcdBTUfHbKR
ukxGOqcDmYCEGOPjTin715iQyHZi2B3P6JYJR+lJxJg67X+8bUUAPWEBMbQxeQdUl/gYQ0rl
ucsTxOMJAz3c1pikYrv/57gFTf94+ACNT/NtFxKtKul6vMTo/bkec0doueJ1xAVPXbM0zpKg
HyQgZNdTDNSt+8eoJFGYOLAYFq0quWqh7xwxfY4etOrNSotygtXV6GPmolLjD776OhMp7KMQ
aimrWi81HOjnLACuKc4NQcT90NtMiKISQ7u5NyQsXzHHzaKk8Bz+yIC9I/oE3KmRGLSF7tNu
9IAYj0BOcoThZlXAS7lKUJRnJfWMVHE3xcAl16cMmGIX6u0y9QiVN/U6HHkt2n8EI/6tQS32
DCyYqBmhSs2Xm8HHEUkNrJiGk7WsHxFs/q7Xk7EFEz6+mU3L2XhkAVkeU7ByXsWehUALkl2v
5z9YMN24cxlQPXvkyi5TEB4gBiQmeowZiVg/OuhTB1wZfhmC1B3ieqNg9UK3QnVwLybB00KB
s6JIfc4wvCxMZc4Udz58HgaMJlTmPPimxvKM8F7U5kKtbU1xoWtfm3VmN/GJp8KXB5tWFmBe
NZ4yFwYUPWJwMI2PpHng2G1BQAYMz7gmn6T4ODGccWDOynE8TZNSeS938dUDOGXIEfSTfyeK
/V1C+loM0wLNma7IFN3cAJXQ/1Sq/wfqobsgUqoAAA==

--WIyZ46R2i8wDzkSu--
