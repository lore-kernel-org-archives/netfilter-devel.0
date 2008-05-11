From: "cyx" <cyx@fiberhome.com.cn>
Subject: why iptc_commit failed? help!
Date: Sun, 11 May 2008 21:05:14 +0800
Message-ID: <200805112105139532310@fiberhome.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [61.183.207.101] ([61.183.207.101]:61741 "EHLO
	mail.fiberhome.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYEKNXL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 09:23:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

My test code :


#include <syslog.h>
#include <errno.h>
#include "libiptc/libiptc.h"
#include "iptables.h"

int proxy_add_masquerade(char *iface)
{
	int i;
	iptc_handle_t h;
	struct ipt_entry * e=NULL;
	struct ipt_entry_target * pt;
	size_t target_size,size;
	
	h = iptc_init("nat");
	if(!h)
	{
		printf("iptc_init() failed : %s", iptc_strerror(errno));
		return -1;
	}
	
	target_size=IPT_ALIGN(sizeof(struct ipt_entry_target))+IPT_ALIGN(sizeof(int));
	size=sizeof(*e)+target_size;
	
	e=(const struct ipt_entry *)calloc(1,size);
	strcpy(e->ip.outiface,iface);
	for(i=0;i<strlen(iface)+1;i++)
e->ip.outiface_mask[i]=0xff;
	e->target_offset=sizeof(*e);
	e->next_offset=size;
	
	pt=(struct ipt_entry_target *)e->elems;
	pt->u.user.target_size=target_size;
	strcpy(pt->u.user.name,"MASQUERADE");
	
	if(0==iptc_append_entry("POSTROUTING",e,&h))
		{
			free(e);
			printf("iptc_append_entry failed : %s", iptc_strerror(errno));
			return -1;
		}
		if(0==iptc_commit(&h))
		{
			free(e);
			printf("iptc_commit failed : %s", iptc_strerror(errno));
			printf("%d",errno);
			return -1;
		}	
	free(e);
	return 0;
}	
int main(void)
{
int ret=0;
ret=proxy_add_masquerade("eth0");
printf("%d",ret);
}

bus it doesn' work right,          iptc_strerror(errno) is "Unknow error 4294967295-1" errno is -1. why? help me :-(

