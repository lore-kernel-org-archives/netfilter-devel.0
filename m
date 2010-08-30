From: Justin Kamerman <justin@kaleco.net>
Subject: Re: write a new simple target for netfilter
Date: Mon, 30 Aug 2010 11:34:02 -0300
Message-ID: <4C7BC15A.7060204@kaleco.net>
References: <AANLkTikwLOzN8ycsVxtXy6f57=Y0MG=dMp04v4r8O3cp@mail.gmail.com>	<AANLkTinLYRcgf3rxWYMMFZ5BmVdQgTojKExtpNbY-Jo7@mail.gmail.com>	<4C7BB8DF.7040208@kaleco.net> <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
Reply-To: justin@kaleco.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050107030208030108030900"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37407 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0H3OeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:34:05 -0400
Received: by qyk33 with SMTP id 33so5192779qyk.19
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Aug 2010 07:34:04 -0700 (PDT)
In-Reply-To: <AANLkTimwoCiP=XYaiNp4MMb4krHsF8QebJULfe5fv8Em@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050107030208030108030900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Nicola,
attached is the sample code from the "Writing Netfilter modules"
tutorial. It builds and installs a filter module ipaddr for the running
kernel:

make all install

Hope this helps.

Regards,
Justin Kamerman

On 10-08-30 11:21 AM, Nicola Padovano wrote:
> ok justin thank you!
> for now I only need standalone package (to test my code, in future i
> will see how xtables-addons works).
> but (there is always a "but")  the problem, justin, isn't the copy of
> libxt_foo.so in /lib/xtables, but it is the creation of this library.
> as i said before, when i compile the module i don't have no
> lixt_foo.so file. So, how i can create it?
>
> sorry for my ignorance, i've started with kernel programming only a few day ago.
>
> thanks!
>
> On Mon, Aug 30, 2010 at 3:57 PM, Justin Kamerman <justin@kaleco.net> wrote:
>   
>> Nicola,
>> iptables is complaining because it can't locate the userspace companion
>> to your netfilter module. The userspace companion tells iptables which
>> kernel module to load and parses command line options before they are
>> passed to the kernel module. The module_install target takes care of the
>> kernel module but you also need a userspace helper installed to
>> /lib/xtables. If building standalone (as opposed to using the
>> Xtables-addons framework) you could use a maekfile rule like:
>>
>> libs_install:
>>        cp -f libxt_ipaddr.so /lib/xtables
>>
>> Regards,
>> Justin Kamerman
>>
>> On 10-08-30 10:25 AM, Nicola Padovano wrote:
>>     
>>> -s 127.0.0.1 -p icmp -j DROP
>>>       
>>>> but i don't know how create this new target...
>>>> I've modified the netfilter makefile e Kbuild file (in net/netfilter)
>>>>         
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>     
>
>
>   

--------------050107030208030108030900
Content-Type: text/x-csrc;
 name="libxt_ipaddr.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libxt_ipaddr.c"

/* Shared library add-on to iptables to add ipaddr support. */

#include <stdio.h>
#include <getopt.h>
#include <string.h>
#include <arpa/inet.h>
#include <xtables.h>
#include "xt_ipaddr.h"


/**
 * If we have a rule we want to save, iptables provides the tool
 * iptables-save which dumps all your rules. It needs your extension's
 * help to interpret struct xt_ipaddr_mtinfo's contents and and dump
 * proper rules. The output that is produced must be options that can
 * be passed to iptables 
*/
static void ipaddr_mt4_save (const void *entry, const struct xt_entry_match *match)
{
    const struct xt_ipaddr_mtinfo *info = (const void *) match->data;

    /* Print the source address if it is part of the rule */
    if (info->flags & XT_IPADDR_SRC)
    {
        if (info->flags & XT_IPADDR_SRC_INV)
            printf ("! ");

        printf ("--ipsrc %s ", xtables_ipaddr_to_numeric (&info->src.in));
    }

    /* Print the destination address if it is part of the rule */
    if (info->flags & XT_IPADDR_DST)
    {
        if (info->flags & XT_IPADDR_DST_INV)
            printf ("! ");

        printf ("--ipdst %s ", xtables_ipaddr_to_numeric (&info->dst.in));
    }
}


/**
 * In the same philosophy as the save function, this function aims to
 * print information about the rule. It is called by iptables -L, and
 * you are free to output whatever you want and how you want. 
*/
static void ipaddr_mt4_print (const void *entry, 
                              const struct xt_entry_match *match, 
                              int numeric)
{
    const struct xt_ipaddr_mtinfo *info = (const void *) match->data;

    /* Print the source address if it is part of the rule */
    if (info->flags & XT_IPADDR_SRC)
    {
        printf ("src IP ");
        if (info->flags & XT_IPADDR_SRC_INV)
            printf ("! ");
        
        printf ("%s ", numeric ? 
                xtables_ipaddr_to_numeric (&info->src.in) :
                xtables_ipaddr_to_anyname (&info->src.in));
    }

    /* Print the destination address if it is part of the rule */
    if (info->flags & XT_IPADDR_DST)
    {
        printf ("dst IP ");
        if (info->flags & XT_IPADDR_DST_INV)
            printf ("! ");

        printf ("%s ", numeric ?
                xtables_ipaddr_to_numeric (&info->dst.in) :
                xtables_ipaddr_to_anyname (&info->dst.in));
    }
}


/**
 * This funciton verifies if arguments are used correctly and set
 * information we will share with the kernel part. It is called each
 * time an option is found, so if the user provides two options, it
 * will be called twice with the argument code provided in the
 * variable c. The argument code for a specific option is set in the
 * option table. 
*/
static int ipaddr_mt4_parse (int c, 
                             char **argv, 
                             int invert, 
                             unsigned int *flags, 
                             const void *entry, 
                             struct xt_entry_match **match)
{
    struct xt_ipaddr_mtinfo *info = (void *) (*match)->data;
    struct in_addr *addrs, mask;
    unsigned int naddr;

    switch (c)
    {
    case '1': /* --ipsrc */
        if (*flags & XT_IPADDR_SRC)
            xtables_error (PARAMETER_PROBLEM, 
                           "xt_ipaddr: Only use \"--ipsrc once!");
        *flags |= XT_IPADDR_SRC;
        info->flags |= XT_IPADDR_SRC;
        if (invert)
            info->flags |= XT_IPADDR_SRC_INV;
        xtables_ipparse_any (optarg, &addrs, &mask, &naddr);
        if (naddr != 1)
            xtables_error (PARAMETER_PROBLEM, 
                           "%s does not resolve to exactly one address",
                           optarg);
        /* copy the single address */
        memcpy (&info->src.in, addrs, sizeof (*addrs));
        return true;

    case '2': /* --ipdst */
        if (*flags & XT_IPADDR_DST)
            xtables_error (PARAMETER_PROBLEM, 
                           "xt_ipaddr: Only use \"--ipdst once!");
        *flags |= XT_IPADDR_DST;
        info->flags |= XT_IPADDR_DST;        
        if (invert)
            info->flags |= XT_IPADDR_DST_INV;
        xtables_ipparse_any (optarg, &addrs, &mask, &naddr);
        if (naddr != 1)
            xtables_error (PARAMETER_PROBLEM, 
                           "%s does not resolve to exactly one address",
                           optarg);
        /* copy the single address */
        memcpy (&info->dst.in, addrs, sizeof (*addrs));
        return true;
    }   
    
    return false;
}


/**
 * This function is a last chance for a sanity check. It is called
 * when the user enters a new rule, right after argument parsing is
 * done and flags is filled with whatever values you chose to assign
 * to it in your parse function.
 */
static void ipaddr_mt_check (unsigned int flags)
{
    if ( flags == 0 )
        xtables_error (PARAMETER_PROBLEM, 
                       "xt_ipaddr: You need to specify at least "
                       "\"--ipsrc\" or \"--ipdst\".");
}
    

/**
 * The init function can be used to populate our xt_ipaddr_mtinfo
 * structure with defaults before parse is called
*/
static void ipaddr_mt_init (struct xt_entry_match *match)
{
    struct xt_ipaddr_mtinfo *info = (void *) match->data;
    
    /* This default destination address will never actually be used as
     * the parser will not accept a --ipdst without an argument */
    inet_pton (PF_INET, "192.0.2.137", &info->dst.in);
}


/**
 * This funciton is called by iptables -m match_name -h. It shoudl
 * give an overview of the available options and a very brief short
 * description.
*/
static void ipaddr_mt_help (void)
{
    printf ("ipaddr match options:\n"
            "[!] --ipsrc addr    Match source address of packet\n"
            "[!] --ipdst addr    Match destination address of packet\n");
}
                   

static const struct  option ipaddr_mt_opts[] =
{
    { .name = "ipsrc", .has_arg = true, .val = '1' },
    { .name = "ipdst", .has_arg = true, .val = '2' },
    { NULL },
};


static struct xtables_match ipaddr_mt4_reg = 
{
    .version            = XTABLES_VERSION,
    .name               = "ipaddr",
    .revision           = 0,
    .family             = NFPROTO_IPV4,
    .size               = XT_ALIGN (sizeof (struct xt_ipaddr_mtinfo)),
    .userspacesize      = XT_ALIGN (sizeof (struct xt_ipaddr_mtinfo)),
    .help               = ipaddr_mt_help,
    .init               = ipaddr_mt_init,
    .parse              = ipaddr_mt4_parse,
    .final_check        = ipaddr_mt_check,
    .print              = ipaddr_mt4_print,
    .save               = ipaddr_mt4_save,
    .extra_opts         = ipaddr_mt_opts,
};


void _init (void)
{
    xtables_register_match (&ipaddr_mt4_reg);
}
    



--------------050107030208030108030900
Content-Type: text/plain;
 name="Makefile"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Makefile"

IyBJZiBLRVJORUxfUkVMRUFTRSBpcyBkZWZpbmVkIHRoZW4gd2UgaGF2ZSBiZWVuIGNhbGxl
ZCBmcm9tIHRoZQojIGtlcm5lbCBidWlsZCBzeXN0ZW0gYW5kIGNhbiB1c2UgaXRzIGxhbmd1
YWdlLgppZm5lcSAoJChLRVJORUxSRUxFQVNFKSwpCglvYmotbSA6PSB4dF9pcGFkZHIubwoK
IyBPdGhlcndpc2Ugd2Ugd2VyZSBjYWxsZWQgZGlyZWN0bHkgZnJvbSB0aGUgY29tbWFuZCBs
aW5lOyBpbnZva2UgdGhlCiMga2VybmVsIGJ1aWxkIHN5c3RlbS4KZWxzZQoKTU9EVUxFU19E
SVIgOj0gL2xpYi9tb2R1bGVzLyQoc2hlbGwgdW5hbWUgLXIpCktFUk5FTERJUiA6PSAkKE1P
RFVMRVNfRElSKS9idWlsZApDRkxBR1MgPSAtTzIgLVdhbGwKCgouUEhPTlk6IGFsbCBtb2R1
bGVzIGluc3RhbGwgbW9kdWxlc19pbnN0YWxsIGxpYnNfaW5zdGFsbCBjbGVhbgoKYWxsOiBt
b2R1bGVzIGxpYnh0X2lwYWRkci5zbwoKbW9kdWxlczoKCSQoTUFLRSkgLUMgJChLRVJORUxE
SVIpIE09JCRQV0QgJEAKCmluc3RhbGw6IG1vZHVsZXNfaW5zdGFsbCBsaWJzX2luc3RhbGwK
Cm1vZHVsZXNfaW5zdGFsbDoKCSQoTUFLRSkgLUMgJChLRVJORUxESVIpIE09JCRQV0QgJEAK
CmxpYnNfaW5zdGFsbDoKCQljcCAtZiBsaWJ4dF9pcGFkZHIuc28gL2xpYi94dGFibGVzCgpj
bGVhbjoKCSQoUk0pICouc28KCSQoTUFLRSkgLUMgJChLRVJORUxESVIpIE09JCRQV0QgJEAK
CiMgUGF0dGVybiBydWxlcwpsaWIlLnNvOiBsaWIlLm8KCWdjYyAtc2hhcmVkIC1vICRAICRe
OwoKbGliJS5vOiBsaWIlLmMKCWdjYyAke0NGTEFHU30gLURfSU5JVD1saWIkKl9pbml0IC1j
IC1vICRAICQ8OwoKZW5kaWY=
--------------050107030208030108030900
Content-Type: text/x-csrc;
 name="xt_ipaddr.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xt_ipaddr.c"

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/netfilter.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/netfilter/x_tables.h>
#include <linux/skbuff.h>
#include "xt_ipaddr.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Justin Kamerman <justin@kaleco.net>");
MODULE_DESCRIPTION("Xtables: match source/destination address");
MODULE_ALIAS("ipt_ipaddr");


/**
 * the match function
 */
static bool ipaddr_mt (const struct sk_buff *skb, 
                       const struct xt_match_param *par) 
{
    struct tcphdr _tcph;
    const struct tcphdr *th;
    const struct xt_ipaddr_mtinfo *info;
    const struct iphdr *iph;

    /* Sanity check: if we don't have the whole header, drop packet. */    
	th = skb_header_pointer (skb, par->thoff, sizeof (_tcph), &_tcph);
	if (th == NULL) 
    {
		*par->hotdrop = true;
		return false;
	}

    /* Get a handle to data block copied from userspace i.e. match parameters */
    info = par->matchinfo;

    /* Get handle to IPv4 header from packet - can use ip_hdr()
     * because this match family is NFPROTO_IPV4; lower level
     * extension families must use skb_header_pointer() */
    iph = ip_hdr (skb);

    printk (KERN_INFO
            "xt_ipaddr: IN=%s OUT=%s "
            "SRC=" NIPQUAD_FMT " DST=" NIPQUAD_FMT " "
            "IPSRC=" NIPQUAD_FMT " IPDST=" NIPQUAD_FMT "\n",
            (par->in != NULL) ? par->in->name : "",
            (par->out != NULL) ? par->out->name : "",
            NIPQUAD (iph->saddr),
            NIPQUAD (iph->daddr),
            NIPQUAD (info->src),
            NIPQUAD (info->dst));

    /* If the XT_IPADDR_SRC flag has been set, we check whether the
     * source address matches the one specified in the rule. If it
     * does not match, the whole rule will not match so we can already
     * return false here. */
    if (info->flags & XT_IPADDR_SRC)
    {
        if ((iph->saddr != info->src.ip) ^ !!(info->flags & XT_IPADDR_SRC_INV))
        {
            printk (KERN_NOTICE "src IP - no match\n");
            return false;
        }
    }

    /* Here we do the same except we look for the destination address
     * if XT_IPADDR_DST has been set */
    if (info->flags & XT_IPADDR_DST)
    {
        if ((iph->daddr != info->dst.ip) ^ !!(info->flags & XT_IPADDR_DST_INV))
        {
            printk (KERN_NOTICE "dst IP - no match\n");
            return false;
        }
    }

    return true;
}


/**
 * function to check for validity of parameters in our struct and load
 * additional modules required to perform the match.
 */
static bool ipaddr_mt_check (const struct xt_mtchk_param *par)
{
    const struct xt_ipaddr_mtinfo *info = par->matchinfo;

    printk (KERN_INFO "xt_ipaddr: Added a rule with -m ipaddr in "
            "the %s table; this rule is reachable through "
            "hooks 0x%x\n",
            par->table,
            par->hook_mask);

    /* No flags set */
    if (!(info->flags & (XT_IPADDR_SRC | XT_IPADDR_DST)))
    {
        printk (KERN_INFO "xt_ipaddr: testing for nothing\n");
        return false;
    }

    /* Special test just because we can */
    if (ntohl (info->src.ip) == 0xDEADBEEF)
    {
        printk (KERN_INFO "xt_ipaddr: I just thought I do not "
                "want to let you match on 222.173.190.239\n");
        return false;
    }

    return true;
}


/**
 * function to call when rule is deleted to free any reserved space
 * and/or drop additional modules reference counts so they can be
 * unloaded if desired.
 */
static void ipaddr_mt_destroy (const struct xt_mtdtor_param *par)
{
    const struct xt_ipaddr_mtinfo *info = par->matchinfo;
    printk (KERN_INFO "Test for address %08X removed\n" , info->src.ip);
}


/**
 * structure containing all match metadata such as name and function pointer table.
 */
static struct xt_match ipaddr_mt4_reg __read_mostly = 
{
    .name       = "ipaddr",
    .revision   = 0,
    .family     = NFPROTO_IPV4,
    .match      = ipaddr_mt,
    .checkentry = ipaddr_mt_check,
    .destroy    = ipaddr_mt_destroy,
    .matchsize  = XT_ALIGN (sizeof (struct xt_ipaddr_mtinfo)),
    .me         = THIS_MODULE,
};


/**
 * function called on module loading
 */
static int __init ipaddr_mt_init (void)
{
    return xt_register_match (&ipaddr_mt4_reg);
}


/**
 * function called on module unloading
 */
static void __exit ipaddr_mt_exit (void)
{
    xt_unregister_match (&ipaddr_mt4_reg);
}

module_init (ipaddr_mt_init);
module_exit (ipaddr_mt_exit);

--------------050107030208030108030900
Content-Type: text/x-chdr;
 name="xt_ipaddr.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xt_ipaddr.h"

#ifndef _LINUX_NETFILTER_XT_IPADDR_H
#define _LINUX_NETFILTER_XT_IPADDR_H 1

enum 
{
    XT_IPADDR_SRC       = 1 << 0,
    XT_IPADDR_DST       = 1 << 1,
    XT_IPADDR_SRC_INV   = 1 << 2,
    XT_IPADDR_DST_INV   = 1 << 3,
};


struct xt_ipaddr_mtinfo
{
    union nf_inet_addr src, dst;
    __u8 flags;
};

#endif /* _LINUX_NETFILTER_XT_IPADDR_H */

--------------050107030208030108030900--
